import '../../domain/entities/wallet_transaction.dart';

class WalletTransactionModel extends WalletTransaction {
  const WalletTransactionModel({
    required super.transactionCode,
    required super.transactionType,
    required super.amount,
    required super.balance,
    required super.eventMode,
    required super.transactionDate,
    super.remark,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      transactionCode: json['transaction_code'] ?? '',
      transactionType: json['transaction_type'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      eventMode: json['event_mode'] ?? '',
      transactionDate: DateTime.parse(json['transaction_date']),
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_code': transactionCode,
      'transaction_type': transactionType,
      'amount': amount,
      'balance': balance,
      'event_mode': eventMode,
      'transaction_date': transactionDate.toIso8601String(),
      'remark': remark,
    };
  }
}
