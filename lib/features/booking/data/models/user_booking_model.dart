import 'package:zinko_app/features/booking/domain/entities/user_booking_entity.dart';

class UserBookingModel extends UserBookingEntity {
  const UserBookingModel({
    super.bookingId,
    required super.bookingCode,
    super.userId,
    required super.cafeId,
    super.bookingDate,
    super.cafeTimeSlotsId,
    super.cafeWorkspacesId,
    required super.bookingStatus,
    required super.tentativeToken,
    required super.durationHours,
    required super.tentativeCheckInDatetime,
    required super.tentativeCheckOutDatetime,
    super.checkInDatetime,
    super.checkOutDatetime,
    required super.cafeName,
    required super.address,
    required super.phoneNo,
    required super.timeSlot,
    required super.venueImage,
    required super.seatType,
    required super.totalHours,
    required super.totalAmount,
    required super.noOfPersons,
  });

  factory UserBookingModel.fromJson(Map<String, dynamic> json) {
    return UserBookingModel(
      bookingId: json['booking_id'], // Might be null
      bookingCode: json['booking_code'] ?? '',
      userId: json['user_id'], // Might be null
      cafeId: json['cafe_id'] ?? 0,
      bookingDate: json['booking_date'] != null
          ? DateTime.tryParse(json['booking_date'])
          : null,
      cafeTimeSlotsId: json['cafe_time_slots_id'],
      cafeWorkspacesId: json['cafe_workspaces_id'],
      bookingStatus: json['booking_status'] ?? '',
      tentativeToken: double.tryParse(json['tentative_token']?.toString() ?? '0') ?? 0.0,
      durationHours: int.tryParse(json['duration_hours']?.toString() ?? '0') ?? 0,
      tentativeCheckInDatetime: json['tentative_check_in_datetime'] ?? '',
      tentativeCheckOutDatetime: json['tentative_check_out_datetime'] ?? '',
      checkInDatetime: json['check_in_datetime'],
      checkOutDatetime: json['check_out_datetime'],
      cafeName: json['cafe_name'] ?? 'Unknown Cafe',
      address: json['address'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      timeSlot: json['time_slot'] ?? '',
      venueImage: json['venue_image'] ?? '',
      seatType: json['seat_type'] ?? '',
      totalHours: int.tryParse(json['total_hours']?.toString() ?? '0') ?? 0,
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0.0,
      noOfPersons: int.tryParse(json['no_of_persons']?.toString() ?? '0') ?? 0,
    );
  }
}
