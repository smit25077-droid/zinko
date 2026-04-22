import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';
import 'package:zinko_app/features/booking/domain/repositories/workspace_repository.dart';

class GetWorkspaces {
  final WorkspaceRepository repository;

  GetWorkspaces(this.repository);

  Future<Either<Failure, List<WorkspaceEntity>>> call() async {
    return await repository.getWorkspaces();
  }
}
