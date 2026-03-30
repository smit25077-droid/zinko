import '../../domain/entities/booking_entity.dart';

abstract class BookingEvent {}

class GetBookingsEvent extends BookingEvent {}

class AddBookingEvent extends BookingEvent {
  final BookingEntity booking;
  AddBookingEvent(this.booking);
}

class RemoveBookingEvent extends BookingEvent {
  final String id;
  RemoveBookingEvent(this.id);
}

class CompleteBookingEvent extends BookingEvent {
  final String id;
  CompleteBookingEvent(this.id);
}

class FilterBookingsByTabEvent extends BookingEvent {
  final int tabIndex;
  FilterBookingsByTabEvent(this.tabIndex);
}
