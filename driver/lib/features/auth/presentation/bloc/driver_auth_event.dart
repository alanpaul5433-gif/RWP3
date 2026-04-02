part of 'driver_auth_bloc.dart';

sealed class DriverAuthEvent extends Equatable {
  const DriverAuthEvent();
  @override
  List<Object?> get props => [];
}

class DriverAuthCheckRequested extends DriverAuthEvent { const DriverAuthCheckRequested(); }

class DriverEmailLoginRequested extends DriverAuthEvent {
  final String email;
  final String password;
  const DriverEmailLoginRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class DriverEmailSignupRequested extends DriverAuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String gender;
  const DriverEmailSignupRequested({required this.email, required this.password, required this.fullName, required this.gender});
  @override
  List<Object?> get props => [email, password, fullName, gender];
}

class DriverPasswordResetRequested extends DriverAuthEvent {
  final String email;
  const DriverPasswordResetRequested({required this.email});
  @override
  List<Object?> get props => [email];
}

class DriverLogoutRequested extends DriverAuthEvent { const DriverLogoutRequested(); }
