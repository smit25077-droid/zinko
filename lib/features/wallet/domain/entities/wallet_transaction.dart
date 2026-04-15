import 'package:equatable/equatable.dart';

class WalletTransaction extends Equatable {
  final String transactionCode;
  final String transactionType;
  final double amount;
  final double balance;
  final String eventMode;
  final DateTime transactionDate;
  final String? remark;

  const WalletTransaction({
    required this.transactionCode,
    required this.transactionType,
    required this.amount,
    required this.balance,
    required this.eventMode,
    required this.transactionDate,
    this.remark,
  });

  bool get isCredit => transactionType.toLowerCase() == 'credit';

  String get dateStr =>
      "\${transactionDate.day.toString().padLeft(2, '0')} \${_getMonth(transactionDate.month)} \${transactionDate.year}";

  String _getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  List<Object?> get props => [
        transactionCode,
        transactionType,
        amount,
        balance,
        eventMode,
        transactionDate,
        remark,
      ];
}
