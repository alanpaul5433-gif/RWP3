part of 'coupon_bloc.dart';

sealed class CouponState extends Equatable {
  const CouponState();
  @override
  List<Object?> get props => [];
}

class CouponInitial extends CouponState { const CouponInitial(); }
class CouponLoading extends CouponState { const CouponLoading(); }

class CouponsLoaded extends CouponState {
  final List<CouponEntity> coupons;
  const CouponsLoaded(this.coupons);
  @override
  List<Object?> get props => [coupons];
}

class CouponApplied extends CouponState {
  final CouponEntity coupon;
  final double discount;
  const CouponApplied({required this.coupon, required this.discount});
  @override
  List<Object?> get props => [coupon, discount];
}

class CouponError extends CouponState {
  final String message;
  const CouponError(this.message);
  @override
  List<Object?> get props => [message];
}
