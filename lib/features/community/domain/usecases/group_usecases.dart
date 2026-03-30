import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/community_entities.dart';
import '../repositories/community_repository.dart';

class GetGroups implements UseCase<List<GroupEntity>, NoParams> {
  final CommunityRepository repository;

  GetGroups(this.repository);

  @override
  Future<Either<Failure, List<GroupEntity>>> call(NoParams params) async {
    return await repository.getGroups();
  }
}

class ToggleJoinGroup implements UseCase<GroupEntity, String> {
  final CommunityRepository repository;

  ToggleJoinGroup(this.repository);

  @override
  Future<Either<Failure, GroupEntity>> call(String id) async {
    return await repository.toggleJoinGroup(id);
  }
}
