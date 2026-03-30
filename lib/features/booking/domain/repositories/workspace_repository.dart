import '../entities/workspace_entity.dart';

abstract class WorkspaceRepository {
  Future<List<WorkspaceEntity>> getWorkspaces();
  Future<void> toggleFavorite(String id);
  Future<void> toggleBookmark(String id);
}
