import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/booking/domain/entities/booking_entity.dart';
import 'package:zinko_app/features/booking/domain/entities/user_booking_entity.dart';

abstract class BookingRepository {
  Future<Either<Failure, List<BookingEntity>>> getBookings();
  Future<Either<Failure, BookingEntity>> addBooking(BookingEntity booking);
  Future<Either<Failure, void>> cancelBooking(String bookingCode);
  Future<Either<Failure, BookingEntity>> completeBooking(String id);
  Future<Either<Failure, List<UserBookingEntity>>> getUserBookingDetails();
  Future<Either<Failure, void>> userCheckIn(String bookingCode, String otp);
}
