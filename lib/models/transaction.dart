class Transaction {
  final String note;
  final double amount;
  final double balance;
  final DateTime createdAt;

  Transaction({
    required this.note,
    required this.amount,
    required this.balance,
    required this.createdAt,
  });
}
