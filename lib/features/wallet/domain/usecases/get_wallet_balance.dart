import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/wallet/domain/entities/wallet_balance.dart';
import 'package:zinko_app/features/wallet/domain/repositories/wallet_repository.dart';

class GetWalletBalance {
  final WalletRepository repository;

  GetWalletBalance(this.repository);

  Future<Either<Failure, WalletBalance>> call() async {
    return await repository.getBalance();
  }
}
