import 'package:equatable/equatable.dart';

class BookingSelectionState extends Equatable {
  final DateTime selectedDate;
  final DateTime displayMonth;
  final String checkInTime;
  final String checkOutTime;
  final double durationHours;
  final String? selectedTable;
  final int? selectedTableId;
  final int peopleCount;

  const BookingSelectionState({
    required this.selectedDate,
    required this.displayMonth,
    required this.checkInTime,
    required this.checkOutTime,
    required this.durationHours,
    this.selectedTable,
    this.selectedTableId,
    this.peopleCount = 1,
  });

  factory BookingSelectionState.initial() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return BookingSelectionState(
      selectedDate: today,
      displayMonth: DateTime(today.year, today.month, 1),
      checkInTime: '09:00 AM',
      checkOutTime: '11:00 AM',
      durationHours: 1.0,
      peopleCount: 1,
    );
  }

  @override
  List<Object?> get props => [
        selectedDate,
        displayMonth,
        checkInTime,
        checkOutTime,
        durationHours,
        selectedTable,
        selectedTableId,
        peopleCount,
      ];

  BookingSelectionState copyWith({
    DateTime? selectedDate,
    DateTime? displayMonth,
    String? checkInTime,
    String? checkOutTime,
    double? durationHours,
    String? selectedTable,
    int? selectedTableId,
    int? peopleCount,
    bool clearTable = false,
  }) {
    return BookingSelectionState(
      selectedDate: selectedDate ?? this.selectedDate,
      displayMonth: displayMonth ?? this.displayMonth,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      durationHours: durationHours ?? this.durationHours,
      selectedTable:
          clearTable ? selectedTable : (selectedTable ?? this.selectedTable),
      selectedTableId: clearTable
          ? selectedTableId
          : (selectedTableId ?? this.selectedTableId),
      peopleCount: peopleCount ?? this.peopleCount,
    );
  }
}
