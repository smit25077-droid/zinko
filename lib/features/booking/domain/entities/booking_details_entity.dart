import 'package:equatable/equatable.dart';
import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';

class BookingDetailsEntity extends Equatable {
  final WorkspaceEntity workspace;
  final DateTime date;
  final String checkInTime;
  final String checkOutTime;
  final double duration;
  final int timeSlotId;
  final String table;
  final int? tableId;
  final double subtotal;
  final double tax;
  final double total;
  final int peopleCount;

  const BookingDetailsEntity({
    required this.workspace,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.duration,
    required this.timeSlotId,
    required this.table,
    this.tableId,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.peopleCount = 1,
  });

  @override
  List<Object?> get props => [
        workspace,
        date,
        checkInTime,
        checkOutTime,
        duration,
        timeSlotId,
        table,
        tableId,
        subtotal,
        tax,
        total,
        peopleCount,
      ];
}
