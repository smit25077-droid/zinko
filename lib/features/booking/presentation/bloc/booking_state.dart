import 'package:equatable/equatable.dart';
import '../../domain/entities/user_booking_entity.dart';

abstract class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingsLoaded extends BookingState {
  final List<UserBookingEntity> bookings;
  final int tabIndex;

  const BookingsLoaded(this.bookings, {this.tabIndex = 0});

  @override
  List<Object?> get props => [bookings, tabIndex];

  BookingsLoaded copyWith({
    List<UserBookingEntity>? bookings,
    int? tabIndex,
  }) {
    return BookingsLoaded(
      bookings ?? this.bookings,
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingCheckInLoading extends BookingState {}


class CheckInError extends BookingState {
  final String message;
  const CheckInError(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingOperationSuccess extends BookingState {
  final String message;
  const BookingOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

