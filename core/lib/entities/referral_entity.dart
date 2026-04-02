import 'package:equatable/equatable.dart';

class ReferralEntity extends Equatable {
  final String id;
  final String userId;
  final String referralCode;
  final String? referralBy;
  final String role; // customer, driver
  final DateTime createdAt;

  const ReferralEntity({
    required this.id,
    required this.userId,
    required this.referralCode,
    this.referralBy,
    this.role = 'customer',
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, referralCode];
}
