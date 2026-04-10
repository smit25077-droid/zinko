import 'package:equatable/equatable.dart';

class UserBookingEntity extends Equatable {
  final int bookingId;
  final String bookingCode;
  final int userId;
  final int cafeId;
  final DateTime? bookingDate;
  final int cafeTimeSlotsId;
  final int cafeWorkspacesId;
  final String bookingStatus;
  final double tentativeToken;
  final int durationHours;
  final String tentativeCheckInDatetime;
  final String tentativeCheckOutDatetime;

  const UserBookingEntity({
    required this.bookingId,
    required this.bookingCode,
    required this.userId,
    required this.cafeId,
    this.bookingDate,
    required this.cafeTimeSlotsId,
    required this.cafeWorkspacesId,
    required this.bookingStatus,
    required this.tentativeToken,
    required this.durationHours,
    required this.tentativeCheckInDatetime,
    required this.tentativeCheckOutDatetime,
  });

  @override
  List<Object?> get props => [
        bookingId,
        bookingCode,
        userId,
        cafeId,
        bookingDate,
        cafeTimeSlotsId,
        cafeWorkspacesId,
        bookingStatus,
        tentativeToken,
        durationHours,
        tentativeCheckInDatetime,
        tentativeCheckOutDatetime,
      ];
}
