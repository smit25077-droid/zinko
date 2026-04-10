import '../../domain/entities/booking_request_entity.dart';

class CreateBookingRequestModel extends BookingRequestEntity {
  const CreateBookingRequestModel({
    required super.userId,
    required super.cafeId,
    required super.bookingDate,
    required super.cafeTimeSlotsId,
    required super.cafeWorkspacesId,
    required super.durationHours,
    required super.tentativeCheckInDatetime,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'booking_id': 0,
      'user_id': userId,
      'cafe_id': cafeId,
      'booking_date': bookingDate,
      'cafe_time_slots_id': cafeTimeSlotsId,
      'cafe_workspaces_id': cafeWorkspacesId,
      'duration_hours': durationHours,
      'tentative_check_in_datetime': tentativeCheckInDatetime,
    };
  }
}

class BookingResponseModel extends BookingResponseEntity {
  const BookingResponseModel({required super.bookingCode});

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingResponseModel(
      bookingCode: json['booking_code'] ?? '',
    );
  }
}
