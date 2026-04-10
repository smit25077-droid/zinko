import '../../domain/entities/booking_request_entity.dart';
import '../../domain/entities/workspace_entity.dart';
import '../../domain/repositories/workspace_repository.dart';
import '../datasources/booking_remote_data_source.dart';
import '../datasources/workspace_local_data_source.dart';
import '../models/booking_api_model.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceLocalDataSource localDataSource;
  final BookingRemoteDataSource remoteDataSource;

  WorkspaceRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<WorkspaceEntity>> getWorkspaces() async {
    return await localDataSource.getWorkspaces();
  }

  @override
  Future<void> toggleFavorite(String id) async {
    await localDataSource.toggleFavorite(id);
  }

  @override
  Future<void> toggleBookmark(String id) async {
    await localDataSource.toggleBookmark(id);
  }

  @override
  Future<BookingResponseEntity> createBooking(
      BookingRequestEntity request) async {
    final model = CreateBookingRequestModel(
      userId: request.userId,
      cafeId: request.cafeId,
      bookingDate: request.bookingDate,
      cafeTimeSlotsId: request.cafeTimeSlotsId,
      cafeWorkspacesId: request.cafeWorkspacesId,
      durationHours: request.durationHours,
      tentativeCheckInDatetime: request.tentativeCheckInDatetime,
    );
    return await remoteDataSource.createBooking(model);
  }

  @override
  Future<List<WorkspaceEntity>> searchWorkspaces(String keyword) async {
    return await remoteDataSource.searchWorkspaces(keyword);
  }
}
