import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/user/domain/entities/person_entity.dart';
import 'package:zinko_app/features/community/domain/entities/community_entities.dart';
import 'package:zinko_app/features/community/domain/repositories/community_repository.dart';
import 'package:zinko_app/features/community/data/datasources/community_remote_data_source.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource remoteDataSource;

  CommunityRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    try {
      final remotePosts = await remoteDataSource.getPosts();
      return Right(remotePosts);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> toggleLikePost(String id) async {
    try {
      final updatedPost = await remoteDataSource.toggleLikePost(id);
      return Right(updatedPost);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GroupEntity>>> getGroups() async {
    try {
      final remoteGroups = await remoteDataSource.getGroups();
      return Right(remoteGroups);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> toggleJoinGroup(String id) async {
    try {
      final updatedGroup = await remoteDataSource.toggleJoinGroup(id);
      return Right(updatedGroup);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PersonEntity>>> getPeople() async {
    try {
      final people = await remoteDataSource.getPeople();
      return Right(people);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PersonEntity>> toggleConnection(String id) async {
    try {
      final updatedPerson = await remoteDataSource.toggleConnection(id);
      return Right(updatedPerson);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
