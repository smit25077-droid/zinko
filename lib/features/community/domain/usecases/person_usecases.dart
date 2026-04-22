import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/user/domain/entities/person_entity.dart';
import 'package:zinko_app/features/community/domain/repositories/community_repository.dart';

class GetPeople implements UseCase<List<PersonEntity>, NoParams> {
  final CommunityRepository repository;
  GetPeople(this.repository);

  @override
  Future<Either<Failure, List<PersonEntity>>> call(NoParams params) async {
    return await repository.getPeople();
  }
}

class ToggleConnection implements UseCase<PersonEntity, String> {
  final CommunityRepository repository;
  ToggleConnection(this.repository);

  @override
  Future<Either<Failure, PersonEntity>> call(String id) async {
    return await repository.toggleConnection(id);
  }
}
