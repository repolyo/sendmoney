import 'package:flutter_bloc/flutter_bloc.dart';

class WalletState {
  final double balance;
  final bool showBalance;

  WalletState({this.balance = 1234.56, this.showBalance = false});

  WalletState copyWith({double? balance, bool? showBalance}) {
    return WalletState(
      balance: balance ?? this.balance,
      showBalance: showBalance ?? this.showBalance,
    );
  }
}

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletState());

  void sendMoney(double amount) {}

  void toggleBalance() {
    emit(state.copyWith(showBalance: !state.showBalance));
  }
}
