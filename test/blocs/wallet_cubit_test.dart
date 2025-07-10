import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sendmoney/blocs/wallet_cubit.dart';
import 'package:sendmoney/models/transaction.dart';
import 'package:sendmoney/models/user.dart';
import 'package:sendmoney/services/wallet_service.dart';

class MockWalletService extends Mock implements WalletService {}

class MockTransaction extends Mock implements Transaction {}

void main() {
  group('WalletCubit', () {
    late WalletCubit walletCubit;
    late MockWalletService mockWalletService;
    late User mockUser;

    setUpAll(() {
      registerFallbackValue(MockTransaction());
    });

    setUp(() {
      mockWalletService = MockWalletService();
      walletCubit = WalletCubit(walletService: mockWalletService);
      mockUser = User(id: 1, name: 'Test User', email: 'test@test.com');

      // Set up initial state with a logged-in user
      walletCubit.emit(
        walletCubit.state.copyWith(
          user: mockUser,
          balance: 1234.56,
          transactions: [],
          isBusy: false,
          status: WalletStatus.initial,
        ),
      );
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
      build: () {
        final transaction = Transaction(
          recipientId: mockUser.id,
          note: 'Groceries',
          amount: 100.0,
          balance: 1134.56, // 1234.56 - 100
          createdAt: DateTime.now(),
        );

        when(
          () => mockWalletService.createTransaction(any()),
        ).thenAnswer((_) async => transaction);

        return walletCubit;
      },
      act: (cubit) => cubit.sendMoney('Groceries', 100),
      expect:
          () => [
            isA<WalletState>()
                .having((s) => s.status, 'status', WalletStatus.pending)
                .having((s) => s.isBusy, 'isBusy', true),
            predicate<WalletState>((state) {
              return state.balance == 1134.56 &&
                  state.status == WalletStatus.completed &&
                  state.isBusy == false &&
                  state.error == null &&
                  state.transactions.isNotEmpty &&
                  state.transactions.first.note == 'Groceries' &&
                  state.transactions.first.amount == 100.0;
            }),
          ],
      verify: (_) {
        verify(() => mockWalletService.createTransaction(any())).called(1);
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
