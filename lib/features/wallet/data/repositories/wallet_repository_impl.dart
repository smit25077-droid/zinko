import '../../domain/entities/wallet_balance.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl({required this.remoteDataSource});

  @override
  Future<WalletBalance> getBalance() async {
    return await remoteDataSource.getBalance();
  }

  @override
  Future<List<WalletTransaction>> getTransactions() async {
    return await remoteDataSource.getTransactions();
  }
}
