part of 'coupon_bloc.dart';

sealed class CouponEvent extends Equatable {
  const CouponEvent();
  @override
  List<Object?> get props => [];
}

class CouponsLoadRequested extends CouponEvent { const CouponsLoadRequested(); }

class CouponApplyRequested extends CouponEvent {
  final String code;
  final double orderAmount;
  const CouponApplyRequested({required this.code, required this.orderAmount});
  @override
  List<Object?> get props => [code, orderAmount];
}

class CouponRemoved extends CouponEvent { const CouponRemoved(); }
