import '../entities/workspace_entity.dart';
import '../repositories/workspace_repository.dart';

class GetWorkspaces {
  final WorkspaceRepository repository;

  GetWorkspaces(this.repository);

  Future<List<WorkspaceEntity>> call() async {
    return await repository.getWorkspaces();
  }
}
