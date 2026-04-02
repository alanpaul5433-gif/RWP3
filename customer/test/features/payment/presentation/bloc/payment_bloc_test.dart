import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:customer/features/payment/data/datasources/mock_payment_datasource.dart';
import 'package:customer/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:customer/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PaymentBloc bloc;

  setUp(() {
    final ds = MockPaymentDataSource();
    final repo = PaymentRepositoryImpl(dataSource: ds);
    bloc = PaymentBloc(repository: repo);
  });

  tearDown(() => bloc.close());

  const wait = Duration(seconds: 2);

  blocTest<PaymentBloc, PaymentState>(
    'emits [PaymentMethodReady] on method selection',
    build: () => bloc,
    act: (bloc) =>
        bloc.add(const PaymentMethodSelected(AppConstants.paymentCash)),
    expect: () => [
      const PaymentMethodReady(AppConstants.paymentCash),
    ],
  );

  blocTest<PaymentBloc, PaymentState>(
    'emits [PaymentDeferred] for cash',
    build: () => bloc,
    act: (bloc) => bloc.add(const CashPaymentSelected()),
    expect: () => [const PaymentDeferred()],
  );

  blocTest<PaymentBloc, PaymentState>(
    'emits [PaymentProcessing, PaymentSuccess] for stripe',
    build: () => bloc,
    act: (bloc) =>
        bloc.add(const StripePaymentRequested(amount: 100.0)),
    wait: wait,
    expect: () => [
      const PaymentProcessing(),
      isA<PaymentSuccess>(),
    ],
    verify: (bloc) {
      final state = bloc.state as PaymentSuccess;
      expect(state.method, AppConstants.paymentStripe);
      expect(state.transactionId, startsWith('pi_mock_'));
    },
  );

  blocTest<PaymentBloc, PaymentState>(
    'emits [PaymentProcessing, PaymentSuccess] for wallet with sufficient balance',
    build: () => bloc,
    act: (bloc) => bloc.add(const WalletPaymentRequested(
      userId: 'user_1',
      amount: 30.0,
    )),
    wait: wait,
    expect: () => [
      const PaymentProcessing(),
      isA<PaymentSuccess>(),
    ],
    verify: (bloc) {
      final state = bloc.state as PaymentSuccess;
      expect(state.method, AppConstants.paymentWallet);
      expect(state.newWalletBalance, 20.0);
    },
  );

  blocTest<PaymentBloc, PaymentState>(
    'emits [PaymentProcessing, PaymentFailed] for wallet with insufficient balance',
    build: () => bloc,
    act: (bloc) => bloc.add(const WalletPaymentRequested(
      userId: 'user_1',
      amount: 999.0,
    )),
    wait: wait,
    expect: () => [
      const PaymentProcessing(),
      isA<PaymentFailed>(),
    ],
  );
}
