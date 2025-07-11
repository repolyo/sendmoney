import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sendmoney/models/transaction.dart';
import 'package:sendmoney/models/user.dart';
import 'package:sendmoney/services/wallet_service.dart';

class MockHttpClient {
  late Future<http.Response> Function(Uri uri, {String message}) onGet;
  late Future<http.Response> Function(
    Uri uri, {
    String message,
    Map<String, String>? headers,
    Object? body,
  })
  onPost;

  Future<http.Response> get(Uri uri, {String message = ''}) =>
      onGet(uri, message: message);

  Future<http.Response> post(
    Uri uri, {
    String message = '',
    Map<String, String>? headers,
    Object? body,
  }) => onPost(uri, message: message, headers: headers, body: body);
}

class TestWalletService extends WalletService {
  final MockHttpClient mockClient;

  TestWalletService(this.mockClient);

  @override
  Future<http.Response> get(
    Uri uri, {
    String message = '',
    Duration timeout = const Duration(seconds: 3),
  }) {
    return mockClient.get(uri, message: message);
  }

  @override
  Future<http.Response> post(
    Uri uri, {
    String message = '',
    Map<String, String>? headers,
    Object? body,
    Duration timeout = const Duration(seconds: 3),
  }) {
    return mockClient.post(uri, message: message, headers: headers, body: body);
  }
}

void main() {
  late MockHttpClient mockClient;
  late TestWalletService walletService;
  final user = User(id: 1, name: 'John', email: 'john@test.com');

  setUp(() {
    mockClient = MockHttpClient();
    walletService = TestWalletService(mockClient);
  });

  test('fetchWalletBalance returns correct balance', () async {
    mockClient.onGet = (uri, {message = ''}) async {
      return http.Response(jsonEncode({'balance': 250.75}), 200);
    };

    final balance = await walletService.fetchWalletBalance(user);
    expect(balance, equals(250.75));
  });

  test('fetchWalletBalance returns 0 on missing data', () async {
    mockClient.onGet = (uri, {message = ''}) async {
      return http.Response(jsonEncode([]), 200); // Invalid structure
    };

    expect(
      () => walletService.fetchWalletBalance(user),
      throwsA(isA<Exception>()),
    );
  });

  test('createTransaction returns same transaction', () async {
    final tx = Transaction(
      amount: 50.0,
      recipientId: 1,
      note: 'Test transaction',
      createdAt: DateTime.now(),
    );

    mockClient.onPost = (uri, {message = '', headers, body}) async {
      return http.Response('', 201);
    };

    final result = await walletService.createTransaction(tx);
    expect(result.note, contains('Test transaction'));
    expect(result.amount, equals(50.0));
  });

  test('fetchTransactions returns list of transactions', () async {
    final now = DateTime.now().toIso8601String();
    final data = [
      {
        'id': 1,
        'amount': 100.0,
        'recipientId': user.id,
        'description': 'Payment for services',
        'createdAt': now,
      },
      {
        'id': 2,
        'amount': 150.0,
        'recipientId': user.id,
        'description': 'Refund for overpayment',
        'createdAt': now,
      },
    ];

    mockClient.onGet = (uri, {message = ''}) async {
      return http.Response(jsonEncode(data), 200);
    };

    final txList = await walletService.fetchTransactions(user);
    expect(txList.length, equals(2));
    expect(txList[0].amount, equals(100.0));
  });
}
