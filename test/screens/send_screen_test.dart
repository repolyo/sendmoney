import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendmoney/blocs/wallet_cubit.dart';
import 'package:sendmoney/screens/send_screen.dart';
import 'package:sendmoney/widget/app_button.dart';

void main() {
  group('SendScreen Widget Tests', () {
    late WalletCubit walletCubit;

    setUp(() {
      walletCubit = WalletCubit();
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
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextField).first, 'Alice');
      await tester.enterText(find.byType(TextField).last, '100');
      await tester.pump();

      await tester.tap(find.byType(AppButton));
      await tester.pump(); // trigger loading state
      await tester.pump(const Duration(seconds: 3)); // wait for delay

      expect(find.textContaining('Transaction successful'), findsOneWidget);
    });
  });
}
