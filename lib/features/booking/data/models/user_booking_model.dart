import '../../domain/entities/user_booking_entity.dart';

class UserBookingModel extends UserBookingEntity {
  const UserBookingModel({
    required super.bookingId,
    required super.bookingCode,
    required super.userId,
    required super.cafeId,
    super.bookingDate,
    required super.cafeTimeSlotsId,
    required super.cafeWorkspacesId,
    required super.bookingStatus,
    required super.tentativeToken,
    required super.durationHours,
    required super.tentativeCheckInDatetime,
    required super.tentativeCheckOutDatetime,
  });

  factory UserBookingModel.fromJson(Map<String, dynamic> json) {
    return UserBookingModel(
      bookingId: json['booking_id'] ?? 0,
      bookingCode: json['booking_code'] ?? '',
      userId: json['user_id'] ?? 0,
      cafeId: json['cafe_id'] ?? 0,
      bookingDate: json['booking_date'] != null
          ? DateTime.parse(json['booking_date'])
          : null,
      cafeTimeSlotsId: json['cafe_time_slots_id'] ?? 0,
      cafeWorkspacesId: json['cafe_workspaces_id'] ?? 0,
      bookingStatus: json['booking_status'] ?? '',
      tentativeToken: (json['tentative_token'] ?? 0).toDouble(),
      durationHours: json['duration_hours'] ?? 0,
      tentativeCheckInDatetime: json['tentative_check_in_datetime'] ?? '',
      tentativeCheckOutDatetime: json['tentative_check_out_datetime'] ?? '',
    );
  }
}
