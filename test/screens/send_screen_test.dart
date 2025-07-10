import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sendmoney/blocs/wallet_cubit.dart';
import 'package:sendmoney/models/transaction.dart';
import 'package:sendmoney/models/user.dart';
import 'package:sendmoney/screens/send_screen.dart';
import 'package:sendmoney/services/wallet_service.dart';
import 'package:sendmoney/widget/app_button.dart';

class MockWalletService extends Mock implements WalletService {}

class MockUser extends Mock implements User {}

class MockTransaction extends Mock implements Transaction {}

void main() {
  group('SendScreen Widget Tests', () {
    late WalletCubit walletCubit;
    late MockWalletService mockWalletService;

    setUpAll(() {
      registerFallbackValue(MockUser());
      registerFallbackValue(MockTransaction());
    });

    setUp(() {
      mockWalletService = MockWalletService();
      walletCubit = WalletCubit(walletService: mockWalletService);
      when(() => mockWalletService.fetchWalletBalance(any())).thenAnswer(
        (_) async => Future.delayed(const Duration(seconds: 3), () => 1000),
      );
    });

    tearDown(() {
      walletCubit.close();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: BlocProvider<WalletCubit>.value(
          value: walletCubit,
          child: const SendMoneyScreen(),
        ),
      );
    }

    testWidgets('displays initial UI components', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Recipient'), findsOneWidget);
      expect(find.text('Amount'), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
    });

    testWidgets('shows error if amount is invalid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextField).last, '-10');
      await tester.pump();
      expect(find.text('Enter a valid amount greater than 0'), findsOneWidget);
    });

    testWidgets('shows error if recipient is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextField).first, '');
      await tester.pump();
      expect(find.text('Recipient name is required'), findsOneWidget);
    });

    testWidgets('submits transaction and shows confirmation on success', (
      WidgetTester tester,
    ) async {
      // Set up a mock successful WalletCubit and wrap the widget
      final walletCubit = WalletCubit(walletService: mockWalletService);

      when(() => mockWalletService.createTransaction(any())).thenAnswer(
        (_) async => Transaction(
          recipientId: 1,
          note: 'Alice',
          amount: 100.0,
          balance: 1134.56,
          createdAt: DateTime.now(),
        ),
      );

      // Set up user in the WalletCubit
      walletCubit.emit(
        walletCubit.state.copyWith(
          user: User(id: 1, name: 'Test User', email: 'test@test.com'),
          balance: 1234.56,
          transactions: [],
          isBusy: false,
          status: WalletStatus.initial,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: walletCubit,
            child: const SendMoneyScreen(),
          ),
        ),
      );

      // Enter recipient and amount
      await tester.enterText(find.byType(TextField).first, 'Alice');
      await tester.enterText(find.byType(TextField).last, '100');
      await tester.pumpAndSettle();

      // Tap the submit button
      await tester.tap(find.byType(AppButton));
      await tester.pump(); // Rebuild for loading state
      await tester.pump(); // emit pending
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(); // emit completed

      // Now wait for modal bottom sheet to appear
      await tester.pumpAndSettle();

      expect(find.textContaining('Transaction successful!'), findsOneWidget);
    });
  });
}
