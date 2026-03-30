import '../../domain/entities/workspace_entity.dart';
import '../../domain/repositories/workspace_repository.dart';
import '../datasources/workspace_local_data_source.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceLocalDataSource localDataSource;

  WorkspaceRepositoryImpl({required this.localDataSource});

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
}
