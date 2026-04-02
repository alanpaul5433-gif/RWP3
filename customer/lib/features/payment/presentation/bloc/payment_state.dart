part of 'payment_bloc.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();
  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentMethodReady extends PaymentState {
  final String method;
  const PaymentMethodReady(this.method);

  @override
  List<Object?> get props => [method];
}

class PaymentProcessing extends PaymentState {
  const PaymentProcessing();
}

class PaymentSuccess extends PaymentState {
  final String transactionId;
  final String method;
  final double? newWalletBalance;

  const PaymentSuccess({
    required this.transactionId,
    required this.method,
    this.newWalletBalance,
  });

  @override
  List<Object?> get props => [transactionId, method];
}

class PaymentDeferred extends PaymentState {
  const PaymentDeferred(); // Cash — pay on completion
}

class PaymentFailed extends PaymentState {
  final String message;
  const PaymentFailed(this.message);

  @override
  List<Object?> get props => [message];
}
