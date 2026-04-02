import 'package:equatable/equatable.dart';

class RolePermissionEntity extends Equatable {
  final String id;
  final String roleTitle;
  final bool isEdit;
  final List<PermissionEntity> permissions;

  const RolePermissionEntity({
    required this.id,
    required this.roleTitle,
    this.isEdit = true,
    this.permissions = const [],
  });

  @override
  List<Object?> get props => [id, roleTitle];
}

class PermissionEntity extends Equatable {
  final String title;
  final bool isView;
  final bool isCreate;
  final bool isUpdate;
  final bool isDelete;

  const PermissionEntity({
    required this.title,
    this.isView = false,
    this.isCreate = false,
    this.isUpdate = false,
    this.isDelete = false,
  });

  @override
  List<Object?> get props => [title, isView, isCreate, isUpdate, isDelete];
}
