import 'package:bloc_test/bloc_test.dart';
import 'package:customer/features/auth/data/datasources/mock_auth_datasource.dart';
import 'package:customer/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:customer/features/auth/domain/usecases/login_with_email.dart';
import 'package:customer/features/auth/domain/usecases/signup_with_email.dart';
import 'package:customer/features/auth/domain/usecases/reset_password.dart';
import 'package:customer/features/auth/domain/usecases/get_current_user.dart';
import 'package:customer/features/auth/domain/usecases/logout.dart';
import 'package:customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AuthBloc bloc;
  late MockAuthDataSource dataSource;

  setUp(() {
    dataSource = MockAuthDataSource();
    final repo = AuthRepositoryImpl(dataSource: dataSource);

    bloc = AuthBloc(
      loginWithEmail: LoginWithEmail(repo),
      signupWithEmail: SignupWithEmail(repo),
      resetPassword: ResetPassword(repo),
      getCurrentUser: GetCurrentUser(repo),
      logout: Logout(repo),
    );
  });

  tearDown(() => bloc.close());

  const wait = Duration(seconds: 2);

  group('AuthCheckRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] when no current user',
      build: () => bloc,
      act: (bloc) => bloc.add(const AuthCheckRequested()),
      wait: wait,
      expect: () => [
        const AuthLoading(),
        const Unauthenticated(),
      ],
    );
  });

  group('EmailLoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] on successful login',
      build: () => bloc,
      act: (bloc) => bloc.add(
        const EmailLoginRequested(
          email: 'test@example.com',
          password: 'password123',
        ),
      ),
      wait: wait,
      expect: () => [
        const AuthLoading(),
        isA<Authenticated>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on wrong password',
      build: () => bloc,
      act: (bloc) => bloc.add(
        const EmailLoginRequested(
          email: 'test@example.com',
          password: '123',
        ),
      ),
      wait: wait,
      expect: () => [
        const AuthLoading(),
        isA<AuthError>(),
      ],
    );
  });

  group('EmailSignupRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] on successful signup',
      build: () => bloc,
      act: (bloc) => bloc.add(
        const EmailSignupRequested(
          email: 'new@example.com',
          password: 'password123',
          fullName: 'John Doe',
          gender: 'Male',
        ),
      ),
      wait: wait,
      expect: () => [
        const AuthLoading(),
        isA<Authenticated>(),
      ],
    );
  });

  group('PasswordResetRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, PasswordResetSent] on success',
      build: () => bloc,
      act: (bloc) => bloc.add(
        const PasswordResetRequested(email: 'test@example.com'),
      ),
      wait: wait,
      expect: () => [
        const AuthLoading(),
        const PasswordResetSent(),
      ],
    );
  });

  group('LogoutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] on logout',
      build: () => bloc,
      act: (bloc) => bloc.add(const LogoutRequested()),
      wait: wait,
      expect: () => [
        const AuthLoading(),
        const Unauthenticated(),
      ],
    );
  });
}
