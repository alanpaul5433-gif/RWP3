import 'package:core/core.dart';

class MockDriverAuthDataSource {
  DriverEntity? _currentDriver;

  Future<DriverEntity> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (password.length < 6) throw const AuthException('wrong-password');
    _currentDriver = _createMockDriver(email: email);
    return _currentDriver!;
  }

  Future<DriverEntity> signupWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String gender,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentDriver = _createMockDriver(email: email, fullName: fullName, gender: gender);
    return _currentDriver!;
  }

  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentDriver = null;
  }

  Future<DriverEntity?> getCurrentDriver() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _currentDriver;
  }

  DriverEntity _createMockDriver({
    String email = 'driver@example.com',
    String fullName = 'Test Driver',
    String gender = 'Male',
  }) {
    final now = DateTime.now();
    return DriverEntity(
      id: 'driver_${now.millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
      phoneNumber: '+1987654321',
      gender: gender,
      loginType: AppConstants.loginEmail,
      walletAmount: 250.0,
      totalEarning: 5200.0,
      reviewsCount: 45,
      reviewsSum: 198.0,
      isActive: true,
      isVerified: true,
      isOnline: false,
      vehicleTypeName: 'Sedan',
      vehicleBrandName: 'Toyota',
      vehicleModelName: 'Camry',
      vehicleNumber: 'ABC 1234',
      zoneIds: ['zone_1'],
      createdAt: now,
      updatedAt: now,
    );
  }
}
