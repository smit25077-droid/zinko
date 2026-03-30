import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BookingEntity>>> getBookings() async {
    try {
      final remoteBookings = await remoteDataSource.getBookings();
      return Right(remoteBookings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> addBooking(
      BookingEntity booking) async {
    try {
      final model = BookingModel(
        id: booking.id,
        placeId: booking.placeId,
        placeName: booking.placeName,
        location: booking.location,
        imageUrl: booking.imageUrl,
        date: booking.date,
        timeSlot: booking.timeSlot,
        tableNumber: booking.tableNumber,
        subtotal: booking.subtotal,
        tax: booking.tax,
        total: booking.total,
        isCompleted: booking.isCompleted,
        placeType: booking.placeType,
      );
      final remoteBooking = await remoteDataSource.addBooking(model);
      return Right(remoteBooking);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeBooking(String id) async {
    try {
      await remoteDataSource.removeBooking(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> completeBooking(String id) async {
    try {
      final remoteBooking = await remoteDataSource.completeBooking(id);
      return Right(remoteBooking);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
