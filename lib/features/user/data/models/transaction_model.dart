import 'package:zinko_app/features/user/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.title,
    required super.date,
    required super.amount,
    required super.isCredit,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      title: json['title'] as String,
      date: json['date'] as String,
      amount: (json['amount'] as num).toDouble(),
      isCredit: json['isCredit'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'amount': amount,
      'isCredit': isCredit,
    };
  }
}
