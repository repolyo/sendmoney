import 'dart:convert';

import 'package:sendmoney/error/app_exception.dart';
import 'package:sendmoney/services/http_service.dart';

import '../models/transaction.dart';
import '../models/user.dart';

class WalletService with HttpServiceMixin {
  Future<double> fetchWalletBalance(final User user) async {
    final uri = Uri.parse('$baseUrl/wallet/${user.id}');
    final response = await get(uri, message: 'fetchWalletBalance');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map) {
        return double.tryParse(data['balance'].toString()) ?? 0.0;
      } else {
        throw FetchDataException('Wallet not found');
      }
    } else {
      throw FetchDataException(
        'Failed to fetch wallet: ${response.statusCode}',
      );
    }
  }

  Future<Transaction> createTransaction(Transaction tx) async {
    try {
      final uri = Uri.parse('$baseUrl/transaction');
      final payload = jsonEncode(tx.toJson());
      final response = await post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create transaction');
      }
    } on Exception {
      print('Error creating transaction: ${tx.toJson()}');
    }

    return tx;
  }

  Future<List<Transaction>> fetchTransactions(final User user) async {
    final uri = Uri.parse(
      '$baseUrl/transaction?createdAt_order=desc&recipientId_eq=${user.id}',
    );
    final response = await get(uri, message: 'fetchTransactions');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Transaction.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch transactions');
    }
  }
}
