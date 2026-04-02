import 'package:core/core.dart';

class MockCouponDataSource {
  final List<CouponEntity> _coupons = [
    CouponEntity(
      id: 'cp_1', code: 'FIRST50', discount: 50, isPercentage: false,
      minOrderAmount: 100, maxDiscount: 50,
      expiryDate: DateTime.now().add(const Duration(days: 30)), isPublic: true,
    ),
    CouponEntity(
      id: 'cp_2', code: 'RIDE20', discount: 20, isPercentage: true,
      minOrderAmount: 50, maxDiscount: 100,
      expiryDate: DateTime.now().add(const Duration(days: 60)), isPublic: true,
    ),
    CouponEntity(
      id: 'cp_3', code: 'SAVE10', discount: 10, isPercentage: true,
      minOrderAmount: 30, maxDiscount: 50,
      expiryDate: DateTime.now().add(const Duration(days: 15)), isPublic: true,
    ),
  ];

  Future<List<CouponEntity>> getCoupons() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _coupons.where((c) => c.isActive && !c.isExpired).toList();
  }

  Future<CouponEntity?> validateCoupon(String code, double orderAmount) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final coupon = _coupons.where((c) => c.code == code && c.isActive && !c.isExpired).firstOrNull;
    if (coupon == null) return null;
    if (orderAmount < coupon.minOrderAmount) return null;
    return coupon;
  }
}
