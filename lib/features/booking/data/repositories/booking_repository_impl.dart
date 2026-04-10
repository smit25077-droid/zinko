import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';
import '../models/booking_model.dart';
import '../../domain/entities/user_booking_entity.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BookingEntity>>> getBookings() async {
    try {
      final remoteBookings = await remoteDataSource.getBookings();
      return Right(remoteBookings);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ??
          e.message ??
          'Failed to load bookings';
      return Left(ServerFailure(message));
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
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Failed to add booking';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking(String bookingCode) async {
    try {
      await remoteDataSource.cancelBooking(bookingCode);
      return const Right(null);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Cancellation failed';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> completeBooking(String id) async {
    try {
      final remoteBooking = await remoteDataSource.completeBooking(id);
      return Right(remoteBooking);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ??
          e.message ??
          'Failed to complete booking';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserBookingEntity>>>
      getUserBookingDetails() async {
    try {
      final remoteBookings = await remoteDataSource.getUserBookingDetails();
      return Right(remoteBookings);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ??
          e.message ??
          'Failed to load booking details';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> userCheckIn(
      String bookingCode, String otp) async {
    try {
      await remoteDataSource.userCheckIn(bookingCode, otp);
      return const Right(null);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Check-in failed';
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
