import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/transaction.dart';
import '../models/user.dart';
import '../services/wallet_service.dart';

class WalletState extends Equatable {
  final User? user;
  final double balance;
  final bool showBalance;
  final List<Transaction> transactions;
  final String? error;
  final WalletStatus status; // pending, completed, failed
  final bool isBusy;

  const WalletState({
    this.balance = 1234.56,
    this.transactions = const [],
    this.showBalance = false,
    this.isBusy = false,
    this.status = WalletStatus.initial,
    this.error,
    this.user,
  });

  WalletState copyWith({
    User? user,
    double? balance,
    bool? showBalance,
    bool? isBusy,
    List<Transaction>? transactions,
    WalletStatus? status,
    String? error,
  }) {
    return WalletState(
      user: user ?? this.user,
      balance: balance ?? this.balance,
      showBalance: showBalance ?? this.showBalance,
      transactions: transactions ?? this.transactions,
      isBusy: isBusy ?? this.isBusy,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    user,
    balance,
    showBalance,
    transactions,
    error,
    status,
    isBusy,
  ];
}

class WalletCubit extends Cubit<WalletState> {
  final WalletService walletService;

  WalletCubit({required this.walletService}) : super(WalletState());
  Future<void> loadWalletData(User user) async {
    // called when the user logs in or when the app starts
    // reset user to null and set isBusy to true
    emit(
      state.copyWith(
        user: null,
        isBusy: true,
        error: null,
        status: WalletStatus.pending,
      ),
    );
    try {
      final balance = await walletService.fetchWalletBalance(user);
      final transactions = await walletService.fetchTransactions(user);
      emit(
        state.copyWith(
          user: user,
          balance: balance,
          transactions: transactions,
          isBusy: false,
          status: WalletStatus.completed,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: e.toString(),
          isBusy: false,
          status: WalletStatus.failed,
        ),
      );
    }
  }

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
      try {
        final newTransaction = await walletService.createTransaction(
          Transaction(
            recipientId: state.user!.id,
            note: description,
            amount: amount,
            balance: newBalance,
            createdAt: DateTime.now(),
          ),
        );

        emit(
          state.copyWith(
            balance: newBalance,
            transactions: [newTransaction, ...state.transactions],
            isBusy: false,
            error: null,
            status: WalletStatus.completed,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            isBusy: false,
            status: WalletStatus.failed,
            error: 'Failed to create transaction: $e',
          ),
        );
      }
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
