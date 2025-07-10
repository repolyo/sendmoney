import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendmoney/blocs/auth_cubit.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.scaffoldKey,
    this.title,
    this.drawer,
    this.leading,
    this.actions,
    required this.body,
  });

  final Key? scaffoldKey;
  final String? title;
  final Widget body;
  final Widget? leading;
  final Widget? drawer;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(title ?? ''),
        leading: leading,
        actions: [
          ...?actions,
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
      body: SafeArea(child: body),
      drawer: drawer,
    );
  }
}
