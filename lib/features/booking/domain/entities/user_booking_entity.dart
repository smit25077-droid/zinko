import 'package:equatable/equatable.dart';

class UserBookingEntity extends Equatable {
  final int? bookingId;
  final String bookingCode;
  final int? userId;
  final int cafeId;
  final DateTime? bookingDate;
  final int? cafeTimeSlotsId;
  final int? cafeWorkspacesId;
  final String bookingStatus;
  final double tentativeToken;
  final int durationHours;
  final String tentativeCheckInDatetime;
  final String tentativeCheckOutDatetime;
  // New fields from API
  final String? checkInDatetime;
  final String? checkOutDatetime;
  final String cafeName;
  final String address;
  final String phoneNo;
  final String timeSlot;
  final String venueImage;
  final String seatType;
  final int totalHours;
  final double totalAmount;
  final int noOfPersons;

  const UserBookingEntity({
    this.bookingId,
    required this.bookingCode,
    this.userId,
    required this.cafeId,
    this.bookingDate,
    this.cafeTimeSlotsId,
    this.cafeWorkspacesId,
    required this.bookingStatus,
    required this.tentativeToken,
    required this.durationHours,
    required this.tentativeCheckInDatetime,
    required this.tentativeCheckOutDatetime,
    this.checkInDatetime,
    this.checkOutDatetime,
    required this.cafeName,
    required this.address,
    required this.phoneNo,
    required this.timeSlot,
    required this.venueImage,
    required this.seatType,
    required this.totalHours,
    required this.totalAmount,
    required this.noOfPersons,
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
        checkInDatetime,
        checkOutDatetime,
        cafeName,
        address,
        phoneNo,
        timeSlot,
        venueImage,
        seatType,
        totalHours,
        totalAmount,
        noOfPersons,
      ];
}
