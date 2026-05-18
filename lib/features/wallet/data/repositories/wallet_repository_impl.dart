import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/wallet/domain/entities/wallet_balance.dart';
import 'package:zinko_app/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:zinko_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:zinko_app/features/wallet/data/datasources/wallet_remote_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WalletBalance>> getBalance() async {
    try {
      final result = await remoteDataSource.getBalance();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WalletTransaction>>> getTransactions() async {
    try {
      final result = await remoteDataSource.getTransactions();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
