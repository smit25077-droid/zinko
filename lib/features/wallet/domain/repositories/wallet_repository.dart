import '../../domain/entities/wallet_balance.dart';
import '../../domain/entities/wallet_transaction.dart';

abstract class WalletRepository {
  Future<WalletBalance> getBalance();
  Future<List<WalletTransaction>> getTransactions();
}
