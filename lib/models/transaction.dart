import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  @override
  List<Object?> get props => [note, amount, balance, createdAt];

  /// Creates a new transaction with the given details.
  ///
  /// [note] is a description of the transaction.
  /// [amount] is the amount of money involved in the transaction.
  /// [balance] is the remaining balance after this transaction.
  /// [createdAt] is the timestamp when the transaction was created.
  final String note;
  final double amount;
  final double balance;
  final DateTime createdAt;

  const Transaction({
    required this.note,
    required this.amount,
    required this.balance,
    required this.createdAt,
  });
}
