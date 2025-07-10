import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendmoney/blocs/auth_cubit.dart';

void main() {
  group('AuthCubit', () {
    late AuthCubit authCubit;

    setUp(() {
      authCubit = AuthCubit();
    });

    tearDown(() {
      authCubit.close();
    });

    test('initial state is not authenticated', () {
      expect(authCubit.state.isAuthenticated, false);
    });

    blocTest<AuthCubit, AuthState>(
      'emits [loading, authenticated] when login is correct',
      build: () => authCubit,
      act: (cubit) => cubit.login('tanch@test.com', 'test1234'),
      wait: const Duration(seconds: 1), // simulate delay
      expect:
          () => [
            isA<AuthState>().having((s) => s.isLoading, 'loading', true),
            isA<AuthState>().having(
              (s) => s.isAuthenticated,
              'authenticated',
              true,
            ),
          ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [loading, error] when login is incorrect',
      build: () => authCubit,
      act: (cubit) => cubit.login('wrong', 'user'),
      wait: const Duration(seconds: 1),
      expect:
          () => [
            isA<AuthState>().having((s) => s.isLoading, 'loading', true),
            isA<AuthState>().having(
              (s) => s.error,
              'error',
              'Invalid credentials',
            ),
          ],
    );
  });

  blocTest<AuthCubit, AuthState>(
    'emits [authenticated, unauthenticated] when logout is called',
    build: () => AuthCubit(),
    seed: () => AuthState(isAuthenticated: true),
    act: (cubit) => cubit.logout(),
    expect: () => [AuthState(isAuthenticated: false)],
  );
}
