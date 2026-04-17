import '../entities/workspace_entity.dart';
import '../repositories/workspace_repository.dart';

class WatchWorkspaces {
  final WorkspaceRepository repository;

  WatchWorkspaces(this.repository);

  Stream<List<WorkspaceEntity>> call() {
    return repository.watchWorkspaces();
  }
}
