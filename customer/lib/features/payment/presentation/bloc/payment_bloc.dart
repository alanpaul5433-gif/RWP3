import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../domain/repositories/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _repository;

  PaymentBloc({required PaymentRepository repository})
      : _repository = repository,
        super(const PaymentInitial()) {
    on<PaymentMethodSelected>(_onPaymentMethodSelected);
    on<StripePaymentRequested>(_onStripePaymentRequested);
    on<WalletPaymentRequested>(_onWalletPaymentRequested);
    on<CashPaymentSelected>(_onCashPaymentSelected);
  }

  Future<void> _onPaymentMethodSelected(
    PaymentMethodSelected event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentMethodReady(event.method));
  }

  Future<void> _onStripePaymentRequested(
    StripePaymentRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentProcessing());

    // Step 1: Create payment intent
    final intentResult =
        await _repository.createPaymentIntent(event.amount);

    await intentResult.fold(
      (failure) async =>
          emit(PaymentFailed(mapFailureToMessage(failure))),
      (intentId) async {
        // Step 2: Confirm payment (mock — real Stripe uses PaymentSheet)
        final confirmResult = await _repository.confirmPayment(intentId);
        confirmResult.fold(
          (failure) =>
              emit(PaymentFailed(mapFailureToMessage(failure))),
          (confirmed) => confirmed
              ? emit(PaymentSuccess(
                  transactionId: intentId,
                  method: AppConstants.paymentStripe,
                ))
              : emit(const PaymentFailed('Payment was not confirmed')),
        );
      },
    );
  }

  Future<void> _onWalletPaymentRequested(
    WalletPaymentRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentProcessing());
    final result = await _repository.deductWallet(event.userId, event.amount);
    result.fold(
      (failure) => emit(PaymentFailed(mapFailureToMessage(failure))),
      (newBalance) => emit(PaymentSuccess(
        transactionId: 'wallet_${DateTime.now().millisecondsSinceEpoch}',
        method: AppConstants.paymentWallet,
        newWalletBalance: newBalance,
      )),
    );
  }

  void _onCashPaymentSelected(
    CashPaymentSelected event,
    Emitter<PaymentState> emit,
  ) {
    emit(const PaymentDeferred());
  }
}
