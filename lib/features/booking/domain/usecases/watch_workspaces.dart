import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';
import 'package:zinko_app/features/booking/domain/repositories/workspace_repository.dart';

class WatchWorkspaces {
  final WorkspaceRepository repository;

  WatchWorkspaces(this.repository);

  Stream<List<WorkspaceEntity>> call() {
    return repository.watchWorkspaces();
  }
}
