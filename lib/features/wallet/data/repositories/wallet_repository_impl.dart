import 'package:zinko_app/features/wallet/domain/entities/wallet_balance.dart';
import 'package:zinko_app/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:zinko_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:zinko_app/features/wallet/data/datasources/wallet_remote_data_source.dart';

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
