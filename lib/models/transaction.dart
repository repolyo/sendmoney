import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  @override
  List<Object?> get props => [recipientId, note, amount, balance, createdAt];

  /// Creates a new transaction with the given details.
  ///
  /// [note] is a description of the transaction.
  /// [amount] is the amount of money involved in the transaction.
  /// [balance] is the remaining balance after this transaction.
  /// [createdAt] is the timestamp when the transaction was created.
  final String note;
  final double amount;
  final double? balance;
  final int recipientId;
  final DateTime createdAt;

  const Transaction({
    required this.recipientId,
    required this.note,
    required this.amount,
    required this.createdAt,
    this.balance,
  });

  /// Creates a Transaction from JSON.
  static Transaction fromJson(Map<String, dynamic> json) {
    print('Transaction.fromJson: $json');

    return Transaction(
      recipientId: json['recipientId'],
      note: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Converts the Transaction to JSON.
  Map<String, dynamic> toJson() {
    return {
      'recipientId': recipientId,
      'description': note,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
