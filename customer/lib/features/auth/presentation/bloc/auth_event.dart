part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class EmailLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const EmailLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class EmailSignupRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String gender;
  final String referralCode;

  const EmailSignupRequested({
    required this.email,
    required this.password,
    required this.fullName,
    required this.gender,
    this.referralCode = '',
  });

  @override
  List<Object?> get props => [email, password, fullName, gender, referralCode];
}

class PasswordResetRequested extends AuthEvent {
  final String email;

  const PasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
