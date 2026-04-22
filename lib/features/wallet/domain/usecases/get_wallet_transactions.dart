import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:zinko_app/features/wallet/domain/repositories/wallet_repository.dart';

class GetWalletTransactions {
  final WalletRepository repository;

  GetWalletTransactions(this.repository);

  Future<Either<Failure, List<WalletTransaction>>> call() async {
    return await repository.getTransactions();
  }
}
