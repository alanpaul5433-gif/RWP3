import 'package:bloc_test/bloc_test.dart';
import 'package:customer/features/coupon/data/datasources/mock_coupon_datasource.dart';
import 'package:customer/features/coupon/presentation/bloc/coupon_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CouponBloc bloc;

  setUp(() {
    bloc = CouponBloc(dataSource: MockCouponDataSource());
  });

  tearDown(() => bloc.close());

  const wait = Duration(seconds: 2);

  blocTest<CouponBloc, CouponState>(
    'loads active coupons',
    build: () => bloc,
    act: (bloc) => bloc.add(const CouponsLoadRequested()),
    wait: wait,
    expect: () => [
      const CouponLoading(),
      isA<CouponsLoaded>(),
    ],
    verify: (bloc) {
      final state = bloc.state as CouponsLoaded;
      expect(state.coupons.length, 3);
    },
  );

  blocTest<CouponBloc, CouponState>(
    'applies valid coupon with discount',
    build: () => bloc,
    act: (bloc) => bloc.add(const CouponApplyRequested(code: 'FIRST50', orderAmount: 200)),
    wait: wait,
    expect: () => [isA<CouponApplied>()],
    verify: (bloc) {
      final state = bloc.state as CouponApplied;
      expect(state.discount, 50.0); // fixed $50 discount
    },
  );

  blocTest<CouponBloc, CouponState>(
    'rejects invalid coupon code',
    build: () => bloc,
    act: (bloc) => bloc.add(const CouponApplyRequested(code: 'INVALID', orderAmount: 200)),
    wait: wait,
    expect: () => [isA<CouponError>()],
  );

  blocTest<CouponBloc, CouponState>(
    'applies percentage coupon correctly',
    build: () => bloc,
    act: (bloc) => bloc.add(const CouponApplyRequested(code: 'RIDE20', orderAmount: 300)),
    wait: wait,
    expect: () => [isA<CouponApplied>()],
    verify: (bloc) {
      final state = bloc.state as CouponApplied;
      expect(state.discount, 60.0); // 20% of 300
    },
  );
}
