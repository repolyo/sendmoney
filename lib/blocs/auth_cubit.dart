import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user.dart';
import '../services/user_service.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final bool isAuthenticated;
  final User? user;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.error,
  });

  @override
  List<Object?> get props => [isLoading, isAuthenticated, error];
}

class AuthCubit extends Cubit<AuthState> {
  final UserService userService;

  AuthCubit({required this.userService}) : super(AuthState());

  Future<void> login(String email, String password) async {
    emit(AuthState(isLoading: true));
    try {
      final account = await userService.authenticate(email, password);
      if (account != null) {
        emit(AuthState(user: account, isAuthenticated: true));
      } else {
        emit(const AuthState(error: 'Invalid credentials'));
      }
    } catch (e) {
      emit(AuthState(error: 'Login failed: ${e.toString()}'));
    }
  }

  void logout() {
    emit(
      AuthState(
        user: null,
        isLoading: false,
        isAuthenticated: false,
        error: null,
      ),
    );
  }
}
