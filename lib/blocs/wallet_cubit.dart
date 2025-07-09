import 'package:flutter_bloc/flutter_bloc.dart';

class WalletState {
  final double balance;
  final bool showBalance;
  final String error;

  WalletState({
    this.balance = 1234.56,
    this.showBalance = false,
    this.error = '',
  });

  WalletState copyWith({double? balance, bool? showBalance, String? error}) {
    return WalletState(
      balance: balance ?? this.balance,
      showBalance: showBalance ?? this.showBalance,
      error: error ?? this.error,
    );
  }
}

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletState());

  void sendMoney(final double amount) {
    if (amount <= 0) {
      emit(state.copyWith(error: 'Amount must be > 0'));
    } else if (amount > state.balance) {
      emit(state.copyWith(error: 'Insufficient funds'));
    } else {
      final newBalance = state.balance - amount;
      emit(state.copyWith(balance: newBalance));
    }
  }

  void toggleBalance() {
    emit(state.copyWith(showBalance: !state.showBalance));
  }
}
