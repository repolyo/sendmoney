import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/transaction.dart';

class WalletState {
  final double balance;
  final bool showBalance;
  final List<Transaction> transactions;
  final String error;

  WalletState({
    this.balance = 1234.56,
    this.transactions = const [],
    this.showBalance = false,
    this.error = '',
  });

  WalletState copyWith({
    double? balance,
    bool? showBalance,
    List<Transaction>? transactions,
    String? error,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      showBalance: showBalance ?? this.showBalance,
      transactions: transactions ?? this.transactions,
      error: error ?? this.error,
    );
  }
}

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletState());

  void sendMoney(final String description, final double amount) {
    if (amount <= 0) {
      emit(state.copyWith(error: 'Amount must be > 0'));
    } else if (amount > state.balance) {
      emit(state.copyWith(error: 'Insufficient funds'));
    } else {
      final newBalance = state.balance - amount;
      final newList = [
        Transaction(
          note: description,
          amount: amount,
          balance: newBalance,
          createdAt: DateTime.now(),
        ),
        ...state.transactions,
      ];

      emit(state.copyWith(balance: newBalance, transactions: newList));
    }
  }

  void toggleBalance() {
    emit(state.copyWith(showBalance: !state.showBalance));
  }
}
