import 'package:core/core.dart';

/// Abstract interface for auth data sources.
/// Both MockAuthDataSource and FirebaseAuthDataSource implement this.
abstract class AuthDataSource {
  Future<UserEntity> loginWithEmail(String email, String password);
  Future<UserEntity> signupWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String gender,
    String referralCode = '',
  });
  Future<void> resetPassword(String email);
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}
