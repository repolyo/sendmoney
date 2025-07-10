import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class UserService {
  final String baseUrl = 'https://mockend.com/api/repolyo/sendmoney-api';

  Future<User?> authenticate(String email, String password) async {
    final uri = Uri.parse('$baseUrl/user');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> users = jsonDecode(response.body);
      final user = users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => null,
      );

      if (user != null) {
        return User.fromJson(user);
      }
    }
    return null;
  }
}
