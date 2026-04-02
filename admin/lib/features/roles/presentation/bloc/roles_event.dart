part of 'roles_bloc.dart';

sealed class RolesEvent extends Equatable {
  const RolesEvent();
  @override
  List<Object?> get props => [];
}

class RolesLoadRequested extends RolesEvent { const RolesLoadRequested(); }

class RoleCreateRequested extends RolesEvent {
  final RolePermissionEntity role;
  const RoleCreateRequested(this.role);
  @override
  List<Object?> get props => [role];
}

class RoleDeleteRequested extends RolesEvent {
  final String roleId;
  const RoleDeleteRequested(this.roleId);
  @override
  List<Object?> get props => [roleId];
}
