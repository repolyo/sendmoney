import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sendmoney/error/app_exception.dart';
import 'package:sendmoney/services/user_service.dart';

class MockHttpClient {
  late Future<http.Response> Function(Uri uri) onGet;

  Future<http.Response> get(Uri uri) => onGet(uri);
}

class TestUserService extends UserService {
  final MockHttpClient mockClient;

  TestUserService(this.mockClient);

  @override
  Future<http.Response> get(
    Uri uri, {
    String message = '',
    Duration timeout = const Duration(seconds: 3),
  }) async {
    try {
      final response = await mockClient.get(uri).timeout(timeout);
      return response;
    } on TimeoutException {
      throw AppTimeoutException(message);
    }
  }
}

void main() {
  late MockHttpClient mockClient;
  late TestUserService userService;

  const mockUsers = [
    {
      'id': 1,
      'name': 'John Doe',
      'email': 'john@example.com',
      'password': '123456',
      'recipientId': 10,
      'thumbnailUrl': 'https://example.com/avatar.jpg',
    },
  ];

  setUp(() {
    mockClient = MockHttpClient();
    userService = TestUserService(mockClient);
  });

  test('returns User when email and password match', () async {
    mockClient.onGet = (uri) async {
      return http.Response(jsonEncode(mockUsers), 200);
    };

    final user = await userService.authenticate('john@example.com', '123456');

    expect(user, isNotNull);
    expect(user!.name, equals('John Doe'));
  });

  test('returns null when credentials do not match', () async {
    mockClient.onGet = (uri) async {
      return http.Response(jsonEncode(mockUsers), 200);
    };

    final user = await userService.authenticate(
      'wrong@example.com',
      'wrongpass',
    );

    expect(user, isNull);
  });

  test('returns Guest User on timeout', () async {
    mockClient.onGet = (uri) async {
      await Future.delayed(Duration(seconds: 5));
      return http.Response('Timeout', 408); // this delay triggers timeout
    };

    final user = await userService.authenticate('any@example.com', '123456');

    expect(user, isNotNull);
    expect(user!.email, equals('guest@test.com'));
  });
}
