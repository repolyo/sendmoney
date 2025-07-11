import 'dart:convert';

import 'package:sendmoney/services/http_service.dart';

import '../error/app_exception.dart';
import '../models/user.dart';

class UserService with HttpServiceMixin {
  Future<User?> authenticate(String email, String password) async {
    final uri = Uri.parse('$baseUrl/user');
    try {
      final response = await get(uri);

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
    } on AppTimeoutException {
      return User.fromJson({
        'id': 0,
        'name': 'Guest User',
        'email': 'guest@test.com',
        'recipientId': 0,
        'thumbnailUrl': null,
      });
    }
    return null;
  }
}
