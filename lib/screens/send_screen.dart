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
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _errorText;
  String? _receiverError;

  @override
  void initState() {
    super.initState();
    _receiverController.addListener(_validateRecipient);
    _amountController.addListener(_validateAmount);
  }

  void _validateRecipient() {
    String? error;
    final value = _receiverController.text.trim();
    if (value.isEmpty) {
      error = 'Recipient name is required';
    }

    setState(() {
      _receiverError = error;
    });
  }

  bool _validateAmount() {
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
      _errorText = error;
    });
    return isValid;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showTransactionResult(BuildContext context, String message) {
    final localContext = context;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2, // 20% of screen
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Text(message, style: const TextStyle(fontSize: 18)),
            ),
          ),
    ).whenComplete(() {
      if (!mounted) return;
      localContext.read<WalletCubit>().clearError();
      _receiverController.clear();
      _amountController.clear();
    });
  }

  void _handleSubmit() {
    if (_validateAmount()) {
      final amount = double.tryParse(_amountController.text) ?? 0;
      final description = _receiverController.text.trim();
      context.read<WalletCubit>().sendMoney(description, amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Send Money',
      body: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state.status == WalletStatus.completed ||
              state.status == WalletStatus.failed) {
            _showTransactionResult(
              context,
              state.error == null
                  ? '✅ Transaction successful!'
                  : '❗${state.error}',
            );
          }
        },
        builder:
            (context, state) => Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _receiverController,
                    decoration: InputDecoration(
                      labelText: 'Recipient',
                      border: OutlineInputBorder(),
                      hintText: 'Enter recipient name or message',
                      errorText: _receiverError,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      hintText: 'Enter amount to send',
                      errorText: _errorText,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleSubmit(),
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
                  Spacer(),
                  const SizedBox(height: 20),
                  state.isBusy
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: 'Submit',
                          icon: Icons.send,
                          disabled:
                              _errorText?.isNotEmpty == true ||
                              _receiverError?.isNotEmpty == true,
                          onPressed: _handleSubmit,
                        ),
                      ),
                ],
              ),
            ),
      ),
    );
  }
}
