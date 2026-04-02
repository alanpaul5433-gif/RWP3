part of 'roles_bloc.dart';

sealed class RolesState extends Equatable {
  const RolesState();
  @override
  List<Object?> get props => [];
}

class RolesInitial extends RolesState { const RolesInitial(); }
class RolesLoading extends RolesState { const RolesLoading(); }

class RolesLoaded extends RolesState {
  final List<RolePermissionEntity> roles;
  const RolesLoaded(this.roles);
  @override
  List<Object?> get props => [roles];
}

class RolesError extends RolesState {
  final String message;
  const RolesError(this.message);
  @override
  List<Object?> get props => [message];
}
