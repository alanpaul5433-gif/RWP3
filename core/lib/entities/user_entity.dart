import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String profilePic;
  final String gender;
  final String loginType;
  final String fcmToken;
  final double walletAmount;
  final double loyaltyCredits;
  final int totalRide;
  final bool isActive;
  final String referralCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber = '',
    this.countryCode = '',
    this.profilePic = '',
    this.gender = '',
    this.loginType = '',
    this.fcmToken = '',
    this.walletAmount = 0.0,
    this.loyaltyCredits = 0.0,
    this.totalRide = 0,
    this.isActive = true,
    this.referralCode = '',
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, email, phoneNumber];
}
