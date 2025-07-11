import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendmoney/blocs/auth_cubit.dart';
import 'package:sendmoney/blocs/wallet_cubit.dart';
import 'package:sendmoney/extensions/number_formatting.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _handleRefresh() async {
    if (!mounted) return;
    final user = context.read<AuthCubit>().state.user;
    context.read<WalletCubit>().loadWalletData(user!);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;

    return AppScaffold(
      scaffoldKey: _scaffoldKey,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: GestureDetector(
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          child: CircleAvatar(
            backgroundImage:
                user?.thumbnailUrl?.isNotEmpty == true
                    ? NetworkImage(user?.thumbnailUrl ?? '')
                    : null,
            child: const Icon(Icons.person), // Placeholder icon if image fails
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.help_outline),
          onPressed: () {
            // Navigate to help or support screen
          },
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // Navigate to notifications screen or show modal
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade800,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  '4',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CircleAvatar(
                      backgroundImage:
                          user?.photoUrl?.isNotEmpty == true
                              ? NetworkImage(user?.photoUrl ?? '')
                              : null,
                      radius: 50,
                      child: const Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user?.name ?? '',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                context.read<AuthCubit>().logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
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
                                        ? '₱${state.balance.withThousandSeparator}'
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
