part of 'wallet_bloc.dart';

sealed class WalletEvent extends Equatable {
  const WalletEvent();
  @override
  List<Object?> get props => [];
}

class WalletLoadRequested extends WalletEvent {
  final String userId;
  const WalletLoadRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}

class WalletAddMoneyRequested extends WalletEvent {
  final String userId;
  final double amount;
  final String method;

  const WalletAddMoneyRequested({
    required this.userId,
    required this.amount,
    required this.method,
  });

  @override
  List<Object?> get props => [userId, amount, method];
}

class WalletTransactionsRequested extends WalletEvent {
  final String userId;
  const WalletTransactionsRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}
