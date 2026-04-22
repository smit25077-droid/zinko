import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/booking/domain/entities/booking_request_entity.dart';
import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';
import 'package:zinko_app/features/booking/domain/repositories/workspace_repository.dart';
import 'package:zinko_app/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:zinko_app/features/booking/data/datasources/workspace_local_data_source.dart';
import 'package:zinko_app/features/booking/data/models/booking_api_model.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceLocalDataSource localDataSource;
  final BookingRemoteDataSource remoteDataSource;

  WorkspaceRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<WorkspaceEntity>>> getWorkspaces() async {
    try {
      final result = await localDataSource.getWorkspaces();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<WorkspaceEntity>> watchWorkspaces() {
    return localDataSource.watchWorkspaces();
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(String id) async {
    try {
      await localDataSource.toggleFavorite(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleBookmark(String id) async {
    try {
      await localDataSource.toggleBookmark(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingResponseEntity>> createBooking(
      BookingRequestEntity request) async {
    try {
      final model = CreateBookingRequestModel(
        userId: request.userId,
        cafeId: request.cafeId,
        bookingDate: request.bookingDate,
        cafeTimeSlotsId: request.cafeTimeSlotsId,
        cafeWorkspacesId: request.cafeWorkspacesId,
        durationHours: request.durationHours,
        tentativeCheckInDatetime: request.tentativeCheckInDatetime,
      );
      final result = await remoteDataSource.createBooking(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkspaceEntity>>> searchWorkspaces(String keyword) async {
    try {
      final result = await remoteDataSource.searchWorkspaces(keyword);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
