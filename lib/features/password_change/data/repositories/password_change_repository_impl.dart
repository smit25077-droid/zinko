import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/password_change/domain/repositories/password_change_repository.dart';
import 'package:zinko_app/features/password_change/data/datasources/password_change_remote_data_source.dart';

class PasswordChangeRepositoryImpl implements PasswordChangeRepository {
  final PasswordChangeRemoteDataSource remoteDataSource;

  PasswordChangeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> sendOtp(String email) async {
    try {
      final result = await remoteDataSource.sendOtp(email);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> verifyOtp({required String email, required String otp}) async {
    try {
      final result = await remoteDataSource.verifyOtp(email: email, otp: otp);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> changePassword({required int userCode, required String password}) async {
    try {
      final result = await remoteDataSource.changePassword(userCode: userCode, password: password);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
