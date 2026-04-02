part of 'driver_auth_bloc.dart';

sealed class DriverAuthState extends Equatable {
  const DriverAuthState();
  @override
  List<Object?> get props => [];
}

class DriverAuthInitial extends DriverAuthState { const DriverAuthInitial(); }
class DriverAuthLoading extends DriverAuthState { const DriverAuthLoading(); }

class DriverAuthenticated extends DriverAuthState {
  final DriverEntity driver;
  const DriverAuthenticated(this.driver);
  @override
  List<Object?> get props => [driver];
}

class DriverUnauthenticated extends DriverAuthState { const DriverUnauthenticated(); }
class DriverPasswordResetSent extends DriverAuthState { const DriverPasswordResetSent(); }

class DriverAuthError extends DriverAuthState {
  final String message;
  const DriverAuthError(this.message);
  @override
  List<Object?> get props => [message];
}
