import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sendmoney/blocs/wallet_cubit.dart';
import 'package:sendmoney/widget/app_scaffold.dart';

class HistoryScreen extends StatelessWidget {
  static const String routeName = '/history';

  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Transactions',
      body: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          if (state.transactions.isEmpty) {
            return const Center(child: Text('No transactions yet.'));
          }

          return ListView.builder(
            itemCount: state.transactions.length,
            itemBuilder: (ctx, i) {
              final tx = state.transactions[i];
              return ListTile(
                leading: const Icon(Icons.arrow_upward, color: Colors.green),
                title: Text(tx.note),
                trailing: Text('- ₱${tx.amount.toStringAsFixed(2)}'),
                subtitle: Text(tx.createdAt.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
