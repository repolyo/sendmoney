import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendmoney/screens/dashboard_screen.dart';
import 'package:sendmoney/screens/history_screen.dart';
import 'package:sendmoney/screens/login_screen.dart';
import 'package:sendmoney/screens/send_screen.dart';
import 'package:sendmoney/services/user_service.dart';

import 'blocs/auth_cubit.dart';
import 'blocs/wallet_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(userService: UserService())),
        BlocProvider(create: (_) => WalletCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Send Money',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        SendMoneyScreen.routeName: (context) => const SendMoneyScreen(),
        HistoryScreen.routeName: (context) => const HistoryScreen(),
      },
    );
  }
}
