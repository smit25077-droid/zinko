import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_selection_event.dart';
import 'booking_selection_state.dart';

class BookingSelectionBloc extends Bloc<BookingSelectionEvent, BookingSelectionState> {
  BookingSelectionBloc() : super(BookingSelectionState.initial()) {
    on<ChangeMonthEvent>(_onChangeMonth);
    on<SelectDateEvent>(_onSelectDate);
    on<SelectSlotEvent>(_onSelectSlot);
    on<SelectTableEvent>(_onSelectTable);
  }

  void _onChangeMonth(ChangeMonthEvent event, Emitter<BookingSelectionState> emit) {
    int month = state.displayMonth.month;
    int year = state.displayMonth.year;
    
    if (event.isNext) {
      month++;
      if (month > 12) {
        month = 1;
        year++;
      }
    } else {
      month--;
      if (month < 1) {
        month = 12;
        year--;
      }
    }
    emit(state.copyWith(displayMonth: DateTime(year, month, 1)));
  }

  void _onSelectDate(SelectDateEvent event, Emitter<BookingSelectionState> emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onSelectSlot(SelectSlotEvent event, Emitter<BookingSelectionState> emit) {
    emit(state.copyWith(selectedSlot: event.slot));
  }

  void _onSelectTable(SelectTableEvent event, Emitter<BookingSelectionState> emit) {
    emit(state.copyWith(selectedTable: event.table));
  }
}
