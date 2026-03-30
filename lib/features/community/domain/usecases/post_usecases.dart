import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/community_entities.dart';
import '../repositories/community_repository.dart';

class GetPosts implements UseCase<List<PostEntity>, NoParams> {
  final CommunityRepository repository;

  GetPosts(this.repository);

  @override
  Future<Either<Failure, List<PostEntity>>> call(NoParams params) async {
    return await repository.getPosts();
  }
}

class ToggleLikePost implements UseCase<PostEntity, String> {
  final CommunityRepository repository;

  ToggleLikePost(this.repository);

  @override
  Future<Either<Failure, PostEntity>> call(String id) async {
    return await repository.toggleLikePost(id);
  }
}
