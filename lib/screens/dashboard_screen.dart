import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendmoney/blocs/wallet_cubit.dart';
import 'package:sendmoney/screens/send_screen.dart';

import '../widget/app_button.dart';
import '../widget/app_scaffold.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Send Money',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.showBalance
                                  ? '₱${state.balance.toStringAsFixed(2)}'
                                  : '₱*******',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                state.showBalance
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed:
                                  () =>
                                      context
                                          .read<WalletCubit>()
                                          .toggleBalance(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AppButton(
                              label: 'Send Money',
                              icon: Icons.outbond_outlined,
                              onPressed: () {
                                // Navigate to Send Money Screen
                                Navigator.pushNamed(
                                  context,
                                  SendMoneyScreen.routeName,
                                );
                              },
                            ),
                            AppButton(
                              label: 'Transactions',
                              icon: Icons.history,
                              onPressed: () {
                                // Navigate to Send Money Screen
                                Navigator.pushNamed(context, '/transactions');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
