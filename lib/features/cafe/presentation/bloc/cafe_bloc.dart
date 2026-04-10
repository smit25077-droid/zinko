import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/search_cafes.dart';
import 'cafe_event.dart';
import 'cafe_state.dart';

class CafeBloc extends Bloc<CafeEvent, CafeState> {
  final SearchCafes searchCafes;

  CafeBloc({required this.searchCafes}) : super(CafeInitial()) {
    on<SearchCafesEvent>(_onSearchCafes);
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
