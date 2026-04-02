import 'package:equatable/equatable.dart';

class CouponEntity extends Equatable {
  final String id;
  final String code;
  final double discount;
  final bool isPercentage;
  final double minOrderAmount;
  final double maxDiscount;
  final DateTime expiryDate;
  final bool isActive;
  final bool isPublic;

  const CouponEntity({
    required this.id,
    required this.code,
    required this.discount,
    this.isPercentage = false,
    this.minOrderAmount = 0,
    this.maxDiscount = 0,
    required this.expiryDate,
    this.isActive = true,
    this.isPublic = true,
  });

  bool get isExpired => DateTime.now().isAfter(expiryDate);

  double calculateDiscount(double orderAmount) {
    if (isExpired || !isActive) return 0;
    if (orderAmount < minOrderAmount) return 0;
    if (isPercentage) {
      final disc = orderAmount * discount / 100;
      return maxDiscount > 0 && disc > maxDiscount ? maxDiscount : disc;
    }
    return discount;
  }

  @override
  List<Object?> get props => [id, code, isActive];
}
