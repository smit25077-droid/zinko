import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/wallet/domain/entities/wallet_balance.dart';
import 'package:zinko_app/features/wallet/domain/entities/wallet_transaction.dart';

abstract class WalletRepository {
  Future<Either<Failure, WalletBalance>> getBalance();
  Future<Either<Failure, List<WalletTransaction>>> getTransactions();
}
