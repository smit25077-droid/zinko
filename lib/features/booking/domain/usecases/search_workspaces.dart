import '../entities/workspace_entity.dart';
import '../repositories/workspace_repository.dart';

class SearchWorkspaces {
  final WorkspaceRepository repository;

  SearchWorkspaces(this.repository);

  Future<List<WorkspaceEntity>> call(String keyword) async {
    return await repository.searchWorkspaces(keyword);
  }
}
