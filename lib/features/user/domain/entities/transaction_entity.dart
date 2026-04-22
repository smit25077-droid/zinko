import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String title;
  final String date;
  final double amount;
  final bool isCredit;

  const TransactionEntity({
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
  });

  @override
  List<Object?> get props => [title, date, amount, isCredit];
}
