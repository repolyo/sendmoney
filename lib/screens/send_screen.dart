import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/wallet_cubit.dart';
import '../widget/app_button.dart';
import '../widget/app_scaffold.dart';

class SendMoneyScreen extends StatefulWidget {
  static const String routeName = '/sendMoney';

  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final TextEditingController _amountController = TextEditingController();
  bool _isAmountValid = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_validateAmount);
  }

  void _validateAmount() {
    final value = _amountController.text.trim();
    final amount = double.tryParse(value);
    final balance = context.read<WalletCubit>().state.balance;

    String? error;
    bool isValid = false;

    if (amount == null || amount <= 0) {
      error = 'Enter a valid amount greater than 0';
    } else if (amount > balance) {
      error = 'Amount exceeds available balance';
    } else {
      isValid = true;
    }

    setState(() {
      // Enable/Disable the submit button if the amount is valid or not
      _isAmountValid = isValid;
      _errorText = error;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Send Money',
      body: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Enter amount to send',
                    errorText: _errorText,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 20),
                // show available balance in wallet
                Text(
                  'You have ₱${state.balance.toStringAsFixed(2)} in your wallet.',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: 'Submit',
                    icon: Icons.send,
                    disabled: !_isAmountValid,
                    onPressed: () {
                      // Handle send money logic
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
