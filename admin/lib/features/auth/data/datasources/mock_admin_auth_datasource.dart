import 'package:core/core.dart';

class MockAdminAuthDataSource {
  AdminEntity? _currentAdmin;

  Future<AdminEntity> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final validEmails = ['admin@rwp3.com', 'admin@rwp.com'];
    if (!validEmails.contains(email.toLowerCase()) || password.length < 6) {
      throw const AuthException('Invalid admin credentials');
    }
    _currentAdmin = AdminEntity(
      id: 'admin_1',
      fullName: 'Admin User',
      email: email,
      role: 'admin',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return _currentAdmin!;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentAdmin = null;
  }

  Future<AdminEntity?> getCurrentAdmin() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentAdmin;
  }
}
