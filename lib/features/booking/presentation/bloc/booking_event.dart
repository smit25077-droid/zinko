import '../../domain/entities/booking_entity.dart';

abstract class BookingEvent {}

class GetBookingsEvent extends BookingEvent {}

class AddBookingEvent extends BookingEvent {
  final BookingEntity booking;
  AddBookingEvent(this.booking);
}

class CancelBookingEvent extends BookingEvent {
  final String bookingCode;
  CancelBookingEvent(this.bookingCode);
}

class CompleteBookingEvent extends BookingEvent {
  final String id;
  CompleteBookingEvent(this.id);
}

class FilterBookingsByTabEvent extends BookingEvent {
  final int tabIndex;
  FilterBookingsByTabEvent(this.tabIndex);
}

class UserCheckInEvent extends BookingEvent {
  final String bookingCode;
  final String otp;
  UserCheckInEvent({required this.bookingCode, required this.otp});
}
