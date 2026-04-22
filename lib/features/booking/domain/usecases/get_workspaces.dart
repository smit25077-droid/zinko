import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';
import 'package:zinko_app/features/booking/domain/repositories/workspace_repository.dart';

class GetWorkspaces {
  final WorkspaceRepository repository;

  GetWorkspaces(this.repository);

  Future<List<WorkspaceEntity>> call() async {
    return await repository.getWorkspaces();
  }
}
