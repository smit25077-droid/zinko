import '../../domain/entities/wallet_transaction.dart';
import '../../domain/repositories/wallet_repository.dart';

class GetWalletTransactions {
  final WalletRepository repository;

  GetWalletTransactions(this.repository);

  Future<List<WalletTransaction>> call() async {
    return await repository.getTransactions();
  }
}
