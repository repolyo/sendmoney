import 'package:flutter/material.dart';

import '../widget/app_scaffold.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Send Money',
      body: Center(child: Text('Dashboard')),
    );
  }
}
