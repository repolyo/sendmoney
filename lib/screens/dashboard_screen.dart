import 'package:flutter/material.dart';

import '../widget/app_button.dart';
import '../widget/app_scaffold.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool showBalance = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Send Money',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                          showBalance ? '₱1234.56' : '₱*******',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            showBalance
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              showBalance = !showBalance;
                            });
                          },
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
                            Navigator.pushNamed(context, '/sendMoney');
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
        ),
      ),
    );
  }
}
