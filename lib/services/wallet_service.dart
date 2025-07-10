import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/transaction.dart';
import '../models/user.dart';

class WalletService {
  final String baseUrl = 'https://mockend.com/api/repolyo/sendmoney-api';

  Future<double> fetchWalletBalance(final User user) async {
    final uri = Uri.parse('$baseUrl/wallet/${user.id}');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map) {
        return double.tryParse(data['balance'].toString()) ?? 0.0;
      } else {
        throw Exception('Wallet not found');
      }
    } else {
      throw Exception('Failed to fetch wallet: ${response.statusCode}');
    }
  }

  Future<Transaction> createTransaction(Transaction tx) async {
    final uri = Uri.parse('$baseUrl/transaction');
    final payload = jsonEncode(tx.toJson());
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: payload,
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create transaction');
    }

    return tx;
  }

  Future<List<Transaction>> fetchTransactions(final User user) async {
    final uri = Uri.parse('$baseUrl/transaction?recipientId_eq=${user.id}');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Transaction.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch transactions');
    }
  }
}
