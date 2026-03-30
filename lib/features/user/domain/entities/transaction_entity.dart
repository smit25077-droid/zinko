class TransactionEntity {
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
}
