part of 'admin_auth_bloc.dart';

sealed class AdminAuthEvent extends Equatable {
  const AdminAuthEvent();
  @override
  List<Object?> get props => [];
}

class AdminAuthCheckRequested extends AdminAuthEvent {
  const AdminAuthCheckRequested();
}

class AdminLoginRequested extends AdminAuthEvent {
  final String email;
  final String password;
  const AdminLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AdminLogoutRequested extends AdminAuthEvent {
  const AdminLogoutRequested();
}
