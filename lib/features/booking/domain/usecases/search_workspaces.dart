import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/booking/domain/entities/workspace_entity.dart';
import 'package:zinko_app/features/booking/domain/repositories/workspace_repository.dart';

class SearchWorkspaces {
  final WorkspaceRepository repository;

  SearchWorkspaces(this.repository);

  Future<Either<Failure, List<WorkspaceEntity>>> call(String keyword) async {
    return await repository.searchWorkspaces(keyword);
  }
}
