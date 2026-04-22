import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';
import 'package:zinko_app/features/booking/domain/entities/booking_request_entity.dart';

abstract class WorkspaceRepository {
  Future<Either<Failure, List<WorkspaceEntity>>> getWorkspaces();
  Stream<List<WorkspaceEntity>> watchWorkspaces();
  Future<Either<Failure, void>> toggleFavorite(String id);
  Future<Either<Failure, void>> toggleBookmark(String id);
  Future<Either<Failure, BookingResponseEntity>> createBooking(BookingRequestEntity request);
  Future<Either<Failure, List<WorkspaceEntity>>> searchWorkspaces(String keyword);
}
