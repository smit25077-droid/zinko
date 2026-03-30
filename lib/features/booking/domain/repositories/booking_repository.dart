import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<Either<Failure, List<BookingEntity>>> getBookings();
  Future<Either<Failure, BookingEntity>> addBooking(BookingEntity booking);
  Future<Either<Failure, void>> removeBooking(String id);
  Future<Either<Failure, BookingEntity>> completeBooking(String id);
}
