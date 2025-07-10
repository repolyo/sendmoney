import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendmoney/blocs/wallet_cubit.dart';

void main() {
  group('WalletCubit', () {
    late WalletCubit walletCubit;

    setUp(() {
      walletCubit = WalletCubit();
    });

    tearDown(() {
      walletCubit.close();
    });

    test('initial balance is 1234.56 and no transactions', () {
      expect(walletCubit.state.balance, 1234.56);
      expect(walletCubit.state.transactions, []);
      expect(walletCubit.state.isBusy, false);
      expect(walletCubit.state.status, WalletStatus.initial);
    });

    blocTest<WalletCubit, WalletState>(
      'toggleBalance flips showBalance flag',
      build: () => walletCubit,
      act: (cubit) => cubit.toggleBalance(),
      expect:
          () => [
            isA<WalletState>().having(
              (s) => s.showBalance,
              'showBalance',
              true,
            ),
          ],
    );

    blocTest<WalletCubit, WalletState>(
      'sendMoney with invalid amount shows error',
      build: () => walletCubit,
      act: (cubit) => cubit.sendMoney('grocery', -50),
      expect:
          () => [
            walletCubit.state.copyWith(
              error: 'Amount must be > 0',
              status: WalletStatus.failed,
            ),
          ],
    );

    blocTest<WalletCubit, WalletState>(
      'sendMoney with amount > balance shows error',
      build: () => walletCubit,
      act: (cubit) => cubit.sendMoney('fuel', 2000),
      expect:
          () => [
            isA<WalletState>().having(
              (s) => s.error,
              'error',
              contains('Insufficient'),
            ),
          ],
    );

    blocTest<WalletCubit, WalletState>(
      'emits busy, then completed, and updates balance and transaction list',
      build: () => walletCubit,
      act: (cubit) => cubit.sendMoney('Groceries', 100),
      wait: const Duration(seconds: 3), // match Future.delayed
      expect: () {
        final newBalance = 1234.56 - 100;
        return [
          walletCubit.state.copyWith(
            balance: 1234.56,
            isBusy: true,
            transactions: [],
            error: null,
            status: WalletStatus.pending,
          ),
          predicate<WalletState>((state) {
            return state.balance == newBalance &&
                state.status == WalletStatus.completed &&
                !state.isBusy &&
                state.transactions.isNotEmpty &&
                state.transactions.first.note == 'Groceries' &&
                state.transactions.first.amount == 100;
          }),
        ];
      },
    );

    blocTest<WalletCubit, WalletState>(
      'clearError removes error message',
      build: () => walletCubit,
      seed:
          () => walletCubit.state.copyWith(
            error: 'Something went wrong',
            status: WalletStatus.failed,
          ),
      act: (cubit) => cubit.clearError(),
      expect:
          () => [
            walletCubit.state.copyWith(
              error: null,
              isBusy: false,
              status: WalletStatus.initial,
            ),
          ],
    );
  });
}
