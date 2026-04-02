import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/signup_with_email.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/logout.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmail _loginWithEmail;
  final SignupWithEmail _signupWithEmail;
  final ResetPassword _resetPassword;
  final GetCurrentUser _getCurrentUser;
  final Logout _logout;

  AuthBloc({
    required LoginWithEmail loginWithEmail,
    required SignupWithEmail signupWithEmail,
    required ResetPassword resetPassword,
    required GetCurrentUser getCurrentUser,
    required Logout logout,
  })  : _loginWithEmail = loginWithEmail,
        _signupWithEmail = signupWithEmail,
        _resetPassword = resetPassword,
        _getCurrentUser = getCurrentUser,
        _logout = logout,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<EmailLoginRequested>(_onEmailLoginRequested);
    on<EmailSignupRequested>(_onEmailSignupRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _getCurrentUser(const NoParams());
    result.fold(
      (failure) => emit(const Unauthenticated()),
      (user) => user != null
          ? emit(Authenticated(user))
          : emit(const Unauthenticated()),
    );
  }

  Future<void> _onEmailLoginRequested(
    EmailLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _loginWithEmail(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthError(mapFailureToMessage(failure))),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onEmailSignupRequested(
    EmailSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signupWithEmail(
      SignupParams(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
        gender: event.gender,
        referralCode: event.referralCode,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(mapFailureToMessage(failure))),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _resetPassword(
      ResetPasswordParams(email: event.email),
    );
    result.fold(
      (failure) => emit(AuthError(mapFailureToMessage(failure))),
      (_) => emit(const PasswordResetSent()),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _logout(const NoParams());
    result.fold(
      (failure) => emit(AuthError(mapFailureToMessage(failure))),
      (_) => emit(const Unauthenticated()),
    );
  }
}
