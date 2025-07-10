import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sendmoney/blocs/auth_cubit.dart';
import 'package:sendmoney/models/user.dart';
import 'package:sendmoney/services/user_service.dart';

class MockUserService extends Mock implements UserService {}

void main() {
  const email = 'tanch@test.com';
  const password = 'test1234';
  final testUser = User(id: 1, email: 'tanch@test.com', name: 'Tanch');

  late MockUserService mockUserService;
  late AuthCubit authCubit;

  setUp(() {
    mockUserService = MockUserService();
    authCubit = AuthCubit(userService: mockUserService);
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit', () {
    test('initial state is not authenticated', () {
      expect(authCubit.state.isAuthenticated, false);
    });

    blocTest<AuthCubit, AuthState>(
      'emits [loading, authenticated] when login is correct',
      build: () {
        when(
          () => mockUserService.authenticate(email, password),
        ).thenAnswer((_) async => testUser);
        return authCubit;
      },
      act: (cubit) => cubit.login(email, password),
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
      build: () {
        when(
          () => mockUserService.authenticate(any(), any()),
        ).thenAnswer((_) async => null);
        return authCubit;
      },
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
    build: () => AuthCubit(userService: mockUserService),
    seed: () => AuthState(isAuthenticated: true),
    act: (cubit) => cubit.logout(),
    expect: () => [AuthState(isAuthenticated: false)],
  );
}
