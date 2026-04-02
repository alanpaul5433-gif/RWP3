import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_coupon_datasource.dart';

part 'coupon_event.dart';
part 'coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final MockCouponDataSource _dataSource;

  CouponBloc({required MockCouponDataSource dataSource})
      : _dataSource = dataSource,
        super(const CouponInitial()) {
    on<CouponsLoadRequested>(_onLoad);
    on<CouponApplyRequested>(_onApply);
    on<CouponRemoved>(_onRemove);
  }

  Future<void> _onLoad(CouponsLoadRequested event, Emitter<CouponState> emit) async {
    emit(const CouponLoading());
    try {
      final coupons = await _dataSource.getCoupons();
      emit(CouponsLoaded(coupons));
    } catch (e) {
      emit(CouponError(e.toString()));
    }
  }

  Future<void> _onApply(CouponApplyRequested event, Emitter<CouponState> emit) async {
    try {
      final coupon = await _dataSource.validateCoupon(event.code, event.orderAmount);
      if (coupon == null) {
        emit(const CouponError('Invalid or expired coupon'));
        return;
      }
      final discount = coupon.calculateDiscount(event.orderAmount);
      emit(CouponApplied(coupon: coupon, discount: discount));
    } catch (e) {
      emit(CouponError(e.toString()));
    }
  }

  void _onRemove(CouponRemoved event, Emitter<CouponState> emit) {
    emit(const CouponInitial());
  }
}
