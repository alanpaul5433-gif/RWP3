part of 'wallet_bloc.dart';

sealed class WalletState extends Equatable {
  const WalletState();
  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletLoading extends WalletState {
  const WalletLoading();
}

class WalletProcessing extends WalletState {
  const WalletProcessing();
}

class WalletLoaded extends WalletState {
  final double balance;
  final List<WalletTransactionEntity> transactions;

  const WalletLoaded({required this.balance, required this.transactions});

  @override
  List<Object?> get props => [balance, transactions];
}

class WalletMoneyAdded extends WalletState {
  final double newBalance;
  final double amount;

  const WalletMoneyAdded({required this.newBalance, required this.amount});

  @override
  List<Object?> get props => [newBalance, amount];
}

class WalletTransactionsLoaded extends WalletState {
  final List<WalletTransactionEntity> transactions;
  const WalletTransactionsLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class WalletError extends WalletState {
  final String message;
  const WalletError(this.message);
  @override
  List<Object?> get props => [message];
}
