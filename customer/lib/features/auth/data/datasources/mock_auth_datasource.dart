import 'package:core/core.dart';

class MockAuthDataSource {
  UserEntity? _currentUser;

  Future<UserEntity> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (password.length < 6) {
      throw const AuthException('wrong-password');
    }
    _currentUser = _createMockUser(email: email);
    return _currentUser!;
  }

  Future<UserEntity> signupWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String gender,
    String referralCode = '',
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = _createMockUser(
      email: email,
      fullName: fullName,
      gender: gender,
    );
    return _currentUser!;
  }

  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  Future<UserEntity?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _currentUser;
  }

  UserEntity _createMockUser({
    String email = 'user@example.com',
    String fullName = 'Test User',
    String gender = 'Male',
  }) {
    final now = DateTime.now();
    return UserEntity(
      id: 'mock_user_${now.millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
      phoneNumber: '+1234567890',
      gender: gender,
      loginType: AppConstants.loginEmail,
      walletAmount: 50.0,
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
  }
}
