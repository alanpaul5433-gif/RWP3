part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();
  @override
  List<Object?> get props => [];
}

class PaymentMethodSelected extends PaymentEvent {
  final String method; // cash, wallet, stripe
  const PaymentMethodSelected(this.method);

  @override
  List<Object?> get props => [method];
}

class StripePaymentRequested extends PaymentEvent {
  final double amount;
  const StripePaymentRequested({required this.amount});

  @override
  List<Object?> get props => [amount];
}

class WalletPaymentRequested extends PaymentEvent {
  final String userId;
  final double amount;

  const WalletPaymentRequested({
    required this.userId,
    required this.amount,
  });

  @override
  List<Object?> get props => [userId, amount];
}

class CashPaymentSelected extends PaymentEvent {
  const CashPaymentSelected();
}
