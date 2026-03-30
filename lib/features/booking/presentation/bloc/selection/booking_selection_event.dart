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

class SelectSlotEvent extends BookingSelectionEvent {
  final String slot;
  const SelectSlotEvent(this.slot);
  @override
  List<Object?> get props => [slot];
}

class SelectTableEvent extends BookingSelectionEvent {
  final String table;
  const SelectTableEvent(this.table);
  @override
  List<Object?> get props => [table];
}
