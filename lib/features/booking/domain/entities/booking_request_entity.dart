import 'package:equatable/equatable.dart';

class BookingRequestEntity extends Equatable {
  final int userId;
  final int cafeId;
  final String bookingDate;
  final int cafeTimeSlotsId;
  final String cafeWorkspacesId;
  final int durationHours;
  final String tentativeCheckInDatetime;

  const BookingRequestEntity({
    required this.userId,
    required this.cafeId,
    required this.bookingDate,
    required this.cafeTimeSlotsId,
    required this.cafeWorkspacesId,
    required this.durationHours,
    required this.tentativeCheckInDatetime,
  });

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

  @override
  List<Object?> get props => [
        userId,
        cafeId,
        bookingDate,
        cafeTimeSlotsId,
        cafeWorkspacesId,
        durationHours,
        tentativeCheckInDatetime,
      ];
}

class BookingResponseEntity extends Equatable {
  final String bookingCode;

  const BookingResponseEntity({required this.bookingCode});

  @override
  List<Object?> get props => [bookingCode];
}
