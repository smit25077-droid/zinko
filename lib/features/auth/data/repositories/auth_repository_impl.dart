import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:zinko_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:zinko_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:zinko_app/features/auth/data/models/auth_requests.dart';
import 'package:zinko_app/features/auth/data/models/auth_responses.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthResponse<UserData>>> login(
      LoginRequest params) async {
    try {
      final response = await remoteDataSource.login(params);
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        await localDataSource.cacheUserData(response.data!);
        return Right(response);
      }
      return Left(ServerFailure(response.message));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse<dynamic>>> register(
      RegisterRequest params) async {
    try {
      final response = await remoteDataSource.signup(params);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response);
      }
      return Left(ServerFailure(response.message));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserData?>> getCachedUser() async {
    try {
      final user = await localDataSource.getLastUserData();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
