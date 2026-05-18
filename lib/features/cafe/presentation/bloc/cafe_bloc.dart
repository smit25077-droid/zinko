import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/cafe/domain/usecases/search_cafes.dart';
import 'package:zinko_app/features/cafe/domain/usecases/toggle_wishlist.dart';
import 'package:zinko_app/features/cafe/domain/usecases/get_wishlist.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_event.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_state.dart';
import 'package:zinko_app/utils/network_error_handler.dart';

class CafeBloc extends Bloc<CafeEvent, CafeState> {
  final SearchCafes searchCafes;
  final ToggleWishlist toggleWishlist;
  final GetWishlist getWishlist;

  CafeBloc({
    required this.searchCafes,
    required this.toggleWishlist,
    required this.getWishlist,
  }) : super(CafeInitial()) {
    on<SearchCafesEvent>(_onSearchCafes);
    on<ToggleWishlistEvent>(_onToggleWishlist);
    on<GetWishlistEvent>(_onGetWishlist);
    on<ResetCafeEvent>(_onResetCafe);
  }

  void _onResetCafe(ResetCafeEvent event, Emitter<CafeState> emit) {
    emit(CafeInitial());
  }

  Future<void> _onGetWishlist(
    GetWishlistEvent event,
    Emitter<CafeState> emit,
  ) async {
    emit(CafeLoading());
    try {
      final wishlist = await getWishlist(event.userCode);
      emit(CafeWishlistLoaded(wishlist: wishlist));
    } catch (e) {
      emit(CafeError(message: NetworkErrorHandler.getErrorMessage(e)));
    }
  }

  Future<void> _onToggleWishlist(
    ToggleWishlistEvent event,
    Emitter<CafeState> emit,
  ) async {
    final currentState = state;
    try {
      await toggleWishlist(event.cafeId, event.userCode, event.isWishlist);

      // Effect UI only after successful status code 200
      if (currentState is CafeLoaded) {
        final updatedCafes = currentState.cafes.map((cafe) {
          if (cafe.cafeId == event.cafeId) {
            return cafe.copyWith(isLiked: !cafe.isLiked);
          }
          return cafe;
        }).toList();

        emit(CafeLoaded(
            cafes: updatedCafes, categories: currentState.categories));
      } else if (currentState is CafeWishlistLoaded) {
        final updatedWishlist = currentState.wishlist
            .where((cafe) => cafe.cafeId != event.cafeId)
            .toList();

        emit(CafeWishlistLoaded(wishlist: updatedWishlist));
      }
    } catch (e) {
      emit(CafeError(message: NetworkErrorHandler.getErrorMessage(e)));
    }
  }

  Future<void> _onSearchCafes(
    SearchCafesEvent event,
    Emitter<CafeState> emit,
  ) async {
    if (state is CafeLoading) return;
    emit(CafeLoading());
    try {
      final cafes = await searchCafes(event.keyword);
      
      // Dynamic category selection from venue_type
      final dynamicCategories = cafes
          .map((c) => c.venueType.trim())
          .where((t) => t.isNotEmpty)
          .toSet()
          .toList();
      
      // Sort alphabetically for a better UI experience
      dynamicCategories.sort((a, b) => a.compareTo(b));
      
      final finalCategories = ['All', ...dynamicCategories];
      
      emit(CafeLoaded(cafes: cafes, categories: finalCategories));
    } catch (e) {
      emit(CafeError(message: NetworkErrorHandler.getErrorMessage(e)));
    }
  }
}
