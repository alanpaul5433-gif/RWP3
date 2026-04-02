import 'package:core/core.dart';

class MockRolesDataSource {
  final List<RolePermissionEntity> _roles = [
    RolePermissionEntity(
      id: 'role_admin',
      roleTitle: 'Admin',
      isEdit: false,
      permissions: _allPermissions(true),
    ),
    RolePermissionEntity(
      id: 'role_support',
      roleTitle: 'Support',
      isEdit: true,
      permissions: [
        const PermissionEntity(title: 'Dashboard', isView: true),
        const PermissionEntity(title: 'Customers', isView: true),
        const PermissionEntity(title: 'Drivers', isView: true),
        const PermissionEntity(title: 'Bookings', isView: true),
        const PermissionEntity(title: 'Support', isView: true, isCreate: true, isUpdate: true),
        const PermissionEntity(title: 'SOS Alerts', isView: true),
      ],
    ),
  ];

  static List<PermissionEntity> _allPermissions(bool all) {
    const modules = ['Dashboard', 'Customers', 'Drivers', 'Bookings', 'Vehicles',
      'Zones', 'Banners', 'Coupons', 'Subscriptions', 'Payouts',
      'Support', 'SOS Alerts', 'Roles', 'Employees', 'Settings'];
    return modules.map((m) => PermissionEntity(
      title: m, isView: all, isCreate: all, isUpdate: all, isDelete: all,
    )).toList();
  }

  Future<List<RolePermissionEntity>> getRoles() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_roles);
  }

  Future<RolePermissionEntity> createRole(RolePermissionEntity role) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newRole = RolePermissionEntity(
      id: 'role_${DateTime.now().millisecondsSinceEpoch}',
      roleTitle: role.roleTitle,
      permissions: role.permissions,
    );
    _roles.add(newRole);
    return newRole;
  }

  Future<void> deleteRole(String roleId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _roles.removeWhere((r) => r.id == roleId && r.isEdit);
  }
}
