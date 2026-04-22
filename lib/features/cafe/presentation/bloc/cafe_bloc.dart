import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/cafe/domain/usecases/search_cafes.dart';
import 'package:zinko_app/features/cafe/domain/usecases/toggle_wishlist.dart';
import 'package:zinko_app/features/cafe/domain/usecases/get_wishlist.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_event.dart';
import 'package:zinko_app/features/cafe/presentation/bloc/cafe_state.dart';

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
      emit(CafeError(message: e.toString()));
    }
  }

  Future<void> _onToggleWishlist(
    ToggleWishlistEvent event,
    Emitter<CafeState> emit,
  ) async {
    final currentState = state;
    if (currentState is CafeLoaded) {
      // Optimistic UI update
      final updatedCafes = currentState.cafes.map((cafe) {
        if (cafe.cafeId == event.cafeId) {
          return cafe.copyWith(isLiked: !cafe.isLiked);
        }
        return cafe;
      }).toList();

      emit(CafeLoaded(cafes: updatedCafes));

      try {
        await toggleWishlist(event.cafeId, event.userCode);
        // We could emit a "Success" state or just keep the optimistic update
      } catch (e) {
        // Revert on error
        emit(CafeLoaded(cafes: currentState.cafes));
        emit(CafeError(message: e.toString()));
      }
    } else if (currentState is CafeWishlistLoaded) {
      // Optimistic UI update for wishlist (remove item)
      final updatedWishlist = currentState.wishlist
          .where((cafe) => cafe.cafeId != event.cafeId)
          .toList();

      emit(CafeWishlistLoaded(wishlist: updatedWishlist));

      try {
        await toggleWishlist(event.cafeId, event.userCode);
      } catch (e) {
        // Revert on error
        emit(CafeWishlistLoaded(wishlist: currentState.wishlist));
        emit(CafeError(message: e.toString()));
      }
    }
  }

  Future<void> _onSearchCafes(
    SearchCafesEvent event,
    Emitter<CafeState> emit,
  ) async {
    emit(CafeLoading());
    try {
      final cafes = await searchCafes(event.keyword);
      emit(CafeLoaded(cafes: cafes));
    } catch (e) {
      emit(CafeError(message: e.toString()));
    }
  }
}
