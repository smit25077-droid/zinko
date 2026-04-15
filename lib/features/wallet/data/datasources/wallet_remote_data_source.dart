import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zinko_app/core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/wallet_balance_model.dart';
import '../models/wallet_transaction_model.dart';

abstract class WalletRemoteDataSource {
  Future<WalletBalanceModel> getBalance();
  Future<List<WalletTransactionModel>> getTransactions();
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final DioClient client;
  final SharedPreferences sharedPreferences;

  WalletRemoteDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
  });

  int? get _userCode {
    try {
      final jsonString = sharedPreferences.getString('CACHED_USER_DATA');
      if (jsonString != null) {
        final data = json.decode(jsonString);
        return data['userCode'] ?? data['user_code'];
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<WalletBalanceModel> getBalance() async {
    final userId = _userCode;
    if (userId == null) throw Exception('User not found');

    final response = await client.get('${ApiEndpoints.getWalletBalance}/$userId');
    if (response.statusCode == 200 && response.data != null) {
      if (response.data['data'] != null) {
        return WalletBalanceModel.fromJson(response.data['data']);
      }
    }
    throw Exception(response.data?['message'] ?? 'Failed to get balance');
  }

  @override
  Future<List<WalletTransactionModel>> getTransactions() async {
    final userId = _userCode;
    if (userId == null) throw Exception('User not found');

    final response = await client.get('${ApiEndpoints.getWalletTransactions}/$userId');
    if (response.statusCode == 200 && response.data != null) {
      if (response.data['data'] != null) {
        final List<dynamic> list = response.data['data'];
        return list.map((e) => WalletTransactionModel.fromJson(e)).toList();
      }
    }
    throw Exception(response.data?['message'] ?? 'Failed to get transactions');
  }
}
