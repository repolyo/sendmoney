import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/transaction.dart';

class WalletState {
  final double balance;
  final bool showBalance;
  final List<Transaction> transactions;
  final String error;
  final WalletStatus status; // pending, completed, failed
  final bool isBusy;

  WalletState({
    this.balance = 1234.56,
    this.transactions = const [],
    this.showBalance = false,
    this.isBusy = false,
    this.status = WalletStatus.pending,
    this.error = '',
  });

  WalletState copyWith({
    double? balance,
    bool? showBalance,
    bool? isBusy,
    List<Transaction>? transactions,
    WalletStatus? status,
    String? error,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      showBalance: showBalance ?? this.showBalance,
      transactions: transactions ?? this.transactions,
      isBusy: isBusy ?? this.isBusy,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletState());

  void sendMoney(final String description, final double amount) async {
    if (amount <= 0) {
      emit(
        state.copyWith(
          error: 'Amount must be > 0',
          status: WalletStatus.failed,
        ),
      );
    } else if (amount > state.balance) {
      emit(
        state.copyWith(
          error: 'Insufficient funds',
          status: WalletStatus.failed,
        ),
      );
    } else {
      emit(state.copyWith(isBusy: true, status: WalletStatus.pending));
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

      // TODO: Integrate with REST backend api
      await Future.delayed(Duration(seconds: 3));

      emit(
        state.copyWith(
          balance: newBalance,
          transactions: newList,
          isBusy: false,
          status: WalletStatus.completed,
        ),
      );
    }
  }

  void toggleBalance() {
    emit(state.copyWith(showBalance: !state.showBalance));
  }

  void clearError() {
    emit(
      state.copyWith(error: null, isBusy: false, status: WalletStatus.initial),
    );
  }
}

enum WalletStatus {
  initial('initial'),
  pending('pending'),
  completed('completed'),
  failed('failed');

  const WalletStatus(this.value);

  final String value;

  /// Convert from string to enum
  static WalletStatus fromString(String value) {
    return WalletStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid WalletStatus: $value'),
    );
  }

  /// Convert enum to string
  @override
  String toString() => value;
}
