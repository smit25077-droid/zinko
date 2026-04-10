import 'package:equatable/equatable.dart';

abstract class BookingSelectionEvent extends Equatable {
  const BookingSelectionEvent();
  @override
  List<Object?> get props => [];
}

class ChangeMonthEvent extends BookingSelectionEvent {
  final bool isNext;
  const ChangeMonthEvent({required this.isNext});
  @override
  List<Object?> get props => [isNext];
}

class SelectDateEvent extends BookingSelectionEvent {
  final DateTime date;
  const SelectDateEvent(this.date);
  @override
  List<Object?> get props => [date];
}

class SelectTimeEvent extends BookingSelectionEvent {
  final String time;
  final bool isCheckIn;
  const SelectTimeEvent(this.time, {required this.isCheckIn});
  @override
  List<Object?> get props => [time, isCheckIn];
}

class SelectDurationEvent extends BookingSelectionEvent {
  final double hours;
  const SelectDurationEvent(this.hours);
  @override
  List<Object?> get props => [hours];
}

class SelectTableEvent extends BookingSelectionEvent {
  final String table;
  final int tableId;
  const SelectTableEvent(this.table, this.tableId);
  @override
  List<Object?> get props => [table, tableId];
}

class SelectPeopleEvent extends BookingSelectionEvent {
  final int peopleCount;
  final int? currentTableCapacity;
  const SelectPeopleEvent(this.peopleCount, {this.currentTableCapacity});
  @override
  List<Object?> get props => [peopleCount, currentTableCapacity];
}
