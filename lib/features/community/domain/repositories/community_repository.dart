import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/user/domain/entities/person_entity.dart';
import 'package:zinko_app/features/community/domain/entities/community_entities.dart';

abstract class CommunityRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts();
  Future<Either<Failure, PostEntity>> toggleLikePost(String id);
  Future<Either<Failure, List<GroupEntity>>> getGroups();
  Future<Either<Failure, GroupEntity>> toggleJoinGroup(String id);
  Future<Either<Failure, List<PersonEntity>>> getPeople();
  Future<Either<Failure, PersonEntity>> toggleConnection(String id);
}
