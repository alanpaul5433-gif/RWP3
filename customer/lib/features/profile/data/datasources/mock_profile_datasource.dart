import 'package:core/core.dart';

class MockProfileDataSource {
  final Map<String, UserEntity> _users = {};

  void seedUser(UserEntity user) {
    _users[user.id] = user;
  }

  Future<UserEntity> getProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = _users[userId];
    if (user == null) throw const ServerException('User not found');
    return user;
  }

  Future<UserEntity> updateProfile({
    required String userId,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? gender,
    String? profilePic,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final existing = _users[userId];
    if (existing == null) throw const ServerException('User not found');

    final updated = UserEntity(
      id: existing.id,
      fullName: fullName ?? existing.fullName,
      email: email ?? existing.email,
      phoneNumber: phoneNumber ?? existing.phoneNumber,
      countryCode: existing.countryCode,
      profilePic: profilePic ?? existing.profilePic,
      gender: gender ?? existing.gender,
      loginType: existing.loginType,
      fcmToken: existing.fcmToken,
      walletAmount: existing.walletAmount,
      loyaltyCredits: existing.loyaltyCredits,
      totalRide: existing.totalRide,
      isActive: existing.isActive,
      referralCode: existing.referralCode,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
    _users[userId] = updated;
    return updated;
  }

  Future<void> deleteAccount(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _users.remove(userId);
  }
}
