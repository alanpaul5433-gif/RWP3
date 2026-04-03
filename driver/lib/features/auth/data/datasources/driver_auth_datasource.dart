import 'package:core/core.dart';

/// Abstract interface for driver auth data sources.
abstract class DriverAuthDataSource {
  Future<DriverEntity> loginWithEmail(String email, String password);
  Future<DriverEntity> signupWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String gender,
  });
  Future<void> resetPassword(String email);
  Future<void> logout();
  Future<DriverEntity?> getCurrentDriver();
}
