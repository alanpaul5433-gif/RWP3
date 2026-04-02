import 'package:equatable/equatable.dart';

class LoyaltyPointTransactionEntity extends Equatable {
  final String id;
  final String userId;
  final double points;
  final String action; // earned, redeemed
  final String? bookingId;
  final DateTime createdAt;

  const LoyaltyPointTransactionEntity({
    required this.id,
    required this.userId,
    required this.points,
    required this.action,
    this.bookingId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, points, action];
}
