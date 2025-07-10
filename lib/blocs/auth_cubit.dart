import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class AuthState extends Equatable {
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;
  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  @override
  List<Object?> get props => [isLoading, isAuthenticated, error];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  Future<void> login(String email, String password) async {
    emit(AuthState(isLoading: true));

    try {
      final uri = Uri.parse(
        'https://mockend.com/api/repolyo/sendmoney-api/user',
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);

        final user = users.firstWhere(
          (u) => u['email'] == email && u['password'] == password,
          orElse: () => null,
        );

        if (user != null) {
          emit(AuthState(isAuthenticated: true));
        } else {
          emit(AuthState(error: 'Invalid credentials'));
        }
      } else {
        emit(AuthState(error: 'Server error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(AuthState(error: 'Login failed: $e'));
    }
  }

  void logout() {
    emit(AuthState(isAuthenticated: false));
  }
}
