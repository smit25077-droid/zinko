import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/booking/domain/entities/booking_entity.dart';
import 'package:zinko_app/features/booking/domain/repositories/booking_repository.dart';
import 'package:zinko_app/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:zinko_app/features/booking/data/models/booking_model.dart';
import 'package:zinko_app/features/booking/domain/entities/user_booking_entity.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BookingEntity>>> getBookings() async {
    try {
      final remoteBookings = await remoteDataSource.getBookings();
      return Right(remoteBookings);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e, stackTrace) {
      print('BookingRepository: Error in getBookings: $e');
      print('Stack trace: $stackTrace');
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
      return Left(ServerFailure.fromDioException(e));
    } catch (e, stackTrace) {
      print('BookingRepository: Error in getBookings: $e');
      print('Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking(String bookingCode) async {
    try {
      await remoteDataSource.cancelBooking(bookingCode);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e, stackTrace) {
      print('BookingRepository: Error in getBookings: $e');
      print('Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> completeBooking(String id) async {
    try {
      final remoteBooking = await remoteDataSource.completeBooking(id);
      return Right(remoteBooking);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e, stackTrace) {
      print('BookingRepository: Error in getBookings: $e');
      print('Stack trace: $stackTrace');
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
      return Left(ServerFailure.fromDioException(e));
    } catch (e, stackTrace) {
      print('BookingRepository: Error in getBookings: $e');
      print('Stack trace: $stackTrace');
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
      return Left(ServerFailure.fromDioException(e));
    } catch (e, stackTrace) {
      print('BookingRepository: Error in getBookings: $e');
      print('Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }
}
