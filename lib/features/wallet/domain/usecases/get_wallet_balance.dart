import '../../domain/entities/wallet_balance.dart';
import '../../domain/repositories/wallet_repository.dart';

class GetWalletBalance {
  final WalletRepository repository;

  GetWalletBalance(this.repository);

  Future<WalletBalance> call() async {
    return await repository.getBalance();
  }
}
