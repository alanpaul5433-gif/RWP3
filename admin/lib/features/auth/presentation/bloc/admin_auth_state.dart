part of 'admin_auth_bloc.dart';

sealed class AdminAuthState extends Equatable {
  const AdminAuthState();
  @override
  List<Object?> get props => [];
}

class AdminAuthInitial extends AdminAuthState {
  const AdminAuthInitial();
}

class AdminAuthLoading extends AdminAuthState {
  const AdminAuthLoading();
}

class AdminAuthenticated extends AdminAuthState {
  final AdminEntity admin;
  const AdminAuthenticated(this.admin);
  @override
  List<Object?> get props => [admin];
}

class AdminUnauthenticated extends AdminAuthState {
  const AdminUnauthenticated();
}

class AdminAuthError extends AdminAuthState {
  final String message;
  const AdminAuthError(this.message);
  @override
  List<Object?> get props => [message];
}
