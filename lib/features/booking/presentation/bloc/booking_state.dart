import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_entity.dart';

abstract class BookingState extends Equatable {
  const BookingState();
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingsLoaded extends BookingState {
  final List<BookingEntity> bookings;
  final int tabIndex;

  const BookingsLoaded(this.bookings, {this.tabIndex = 0});

  @override
  List<Object?> get props => [bookings, tabIndex];

  BookingsLoaded copyWith({
    List<BookingEntity>? bookings,
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
