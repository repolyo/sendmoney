import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendmoney/blocs/auth_cubit.dart';
import 'package:sendmoney/blocs/wallet_cubit.dart';
import 'package:sendmoney/screens/send_screen.dart';

import '../widget/app_button.dart';
import '../widget/app_scaffold.dart';
import 'history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<void> _handleRefresh() async {
    if (!mounted) return;
    final user = context.read<AuthCubit>().state.user;
    context.read<WalletCubit>().loadWalletData(user!);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Send Money',
      body: BlocListener<WalletCubit, WalletState>(
        listener: (BuildContext context, WalletState state) {
          if (state.status == WalletStatus.failed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'An error occurred'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: BlocBuilder<WalletCubit, WalletState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: AppButton(
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
                                  ),
                                  Flexible(
                                    child: AppButton(
                                      label: 'Transactions',
                                      icon: Icons.history,
                                      onPressed: () {
                                        // Navigate to Send Money Screen
                                        Navigator.pushNamed(
                                          context,
                                          HistoryScreen.routeName,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 400), // optional: to allow scroll
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
