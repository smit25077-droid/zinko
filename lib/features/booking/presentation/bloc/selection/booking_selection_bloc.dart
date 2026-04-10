import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_selection_event.dart';
import 'booking_selection_state.dart';

class BookingSelectionBloc
    extends Bloc<BookingSelectionEvent, BookingSelectionState> {
  BookingSelectionBloc() : super(BookingSelectionState.initial()) {
    on<ChangeMonthEvent>(_onChangeMonth);
    on<SelectDateEvent>(_onSelectDate);
    on<SelectTimeEvent>(_onSelectTime);
    on<SelectDurationEvent>(_onSelectDuration);
    on<SelectTableEvent>(_onSelectTable);
    on<SelectPeopleEvent>(_onSelectPeople);
  }

  void _onSelectPeople(
      SelectPeopleEvent event, Emitter<BookingSelectionState> emit) {
    final bool shouldClear =
        (event.currentTableCapacity ?? 0) < event.peopleCount;

    emit(state.copyWith(
      peopleCount: event.peopleCount,
      selectedTable: shouldClear ? null : state.selectedTable,
      selectedTableId: shouldClear ? null : state.selectedTableId,
      clearTable: shouldClear,
    ));
  }

  void _onChangeMonth(
      ChangeMonthEvent event, Emitter<BookingSelectionState> emit) {
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

  void _onSelectDate(
      SelectDateEvent event, Emitter<BookingSelectionState> emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onSelectDuration(
      SelectDurationEvent event, Emitter<BookingSelectionState> emit) {
    final checkout = _calculateCheckOut(state.checkInTime, event.hours);
    emit(state.copyWith(
      durationHours: event.hours,
      checkOutTime: checkout,
    ));
  }

  void _onSelectTime(
      SelectTimeEvent event, Emitter<BookingSelectionState> emit) {
    if (event.isCheckIn) {
      final checkout = _calculateCheckOut(event.time, state.durationHours);
      emit(state.copyWith(
        checkInTime: event.time,
        checkOutTime: checkout,
      ));
    } else {
      // Manual checkout selection if needed, still updating duration
      final duration = _calculateDuration(state.checkInTime, event.time);
      emit(state.copyWith(
        checkOutTime: event.time,
        durationHours: duration,
      ));
    }
  }

  void _onSelectTable(
      SelectTableEvent event, Emitter<BookingSelectionState> emit) {
    emit(state.copyWith(
      selectedTable: event.table,
      selectedTableId: event.tableId,
    ));
  }

  String _calculateCheckOut(String checkIn, double durationHrs) {
    try {
      final inTime = _parseTime(checkIn);
      final outTime = inTime.add(Duration(minutes: (durationHrs * 60).round()));
      return _formatTime(outTime);
    } catch (_) {
      return checkIn;
    }
  }

  String _formatTime(DateTime dt) {
    int hour = dt.hour;
    String ampm = 'AM';
    if (hour >= 12) {
      ampm = 'PM';
      if (hour > 12) hour -= 12;
    }
    if (hour == 0) hour = 12;
    final h = hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m $ampm';
  }

  double _calculateDuration(String checkIn, String checkOut) {
    try {
      final inTime = _parseTime(checkIn);
      final outTime = _parseTime(checkOut);

      double diff = outTime.hour +
          (outTime.minute / 60.0) -
          (inTime.hour + (inTime.minute / 60.0));
      if (diff < 0) diff += 24; // Handle overnight if needed
      return diff;
    } catch (e) {
      return 0.0;
    }
  }

  DateTime _parseTime(String timeStr) {
    final parts = timeStr.split(' ');
    final hm = parts[0].split(':');
    int hour = int.parse(hm[0]);
    int minute = int.parse(hm[1]);
    final ampm = parts[1].toUpperCase();

    if (ampm == 'PM' && hour != 12) hour += 12;
    if (ampm == 'AM' && hour == 12) hour = 0;

    return DateTime(2000, 1, 1, hour, minute);
  }
}
