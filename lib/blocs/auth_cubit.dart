import 'package:flutter_bloc/flutter_bloc.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;
  AuthState({this.isLoading = false, this.isAuthenticated = false, this.error});
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  Future<void> login(String email, String password) async {
    emit(AuthState(isLoading: true));
    await Future.delayed(Duration(seconds: 2));
    if (email == 'tanch@test.com' && password == 'test1234') {
      emit(AuthState(isAuthenticated: true));
    } else {
      emit(AuthState(error: 'Invalid credentials'));
    }
  }
}
