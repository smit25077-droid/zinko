import '../entities/workspace_entity.dart';
import '../entities/booking_request_entity.dart';

abstract class WorkspaceRepository {
  Future<List<WorkspaceEntity>> getWorkspaces();
  Stream<List<WorkspaceEntity>> watchWorkspaces();
  Future<void> toggleFavorite(String id);
  Future<void> toggleBookmark(String id);
  Future<BookingResponseEntity> createBooking(BookingRequestEntity request);
  Future<List<WorkspaceEntity>> searchWorkspaces(String keyword);
}
