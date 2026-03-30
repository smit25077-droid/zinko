import 'package:equatable/equatable.dart';

class BookingSelectionState extends Equatable {
  final DateTime selectedDate;
  final DateTime displayMonth;
  final String selectedSlot;
  final String? selectedTable;

  const BookingSelectionState({
    required this.selectedDate,
    required this.displayMonth,
    required this.selectedSlot,
    this.selectedTable,
  });

  factory BookingSelectionState.initial() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return BookingSelectionState(
      selectedDate: today,
      displayMonth: DateTime(today.year, today.month, 1),
      selectedSlot: '09:00 AM – 01:00 PM',
    );
  }

  @override
  List<Object?> get props => [selectedDate, displayMonth, selectedSlot, selectedTable];

  BookingSelectionState copyWith({
    DateTime? selectedDate,
    DateTime? displayMonth,
    String? selectedSlot,
    String? selectedTable,
  }) {
    return BookingSelectionState(
      selectedDate: selectedDate ?? this.selectedDate,
      displayMonth: displayMonth ?? this.displayMonth,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      selectedTable: selectedTable ?? this.selectedTable,
    );
  }
}
