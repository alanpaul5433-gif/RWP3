part of 'bank_bloc.dart';

sealed class BankState extends Equatable {
  const BankState();
  @override
  List<Object?> get props => [];
}

class BankInitial extends BankState { const BankInitial(); }
class BankLoading extends BankState { const BankLoading(); }
class WithdrawalProcessing extends BankState { const WithdrawalProcessing(); }

class BankAccountsLoaded extends BankState {
  final List<BankDetailsEntity> accounts;
  final double walletBalance;
  const BankAccountsLoaded({required this.accounts, required this.walletBalance});
  @override
  List<Object?> get props => [accounts, walletBalance];
}

class WithdrawalSubmitted extends BankState {
  final WithdrawalEntity withdrawal;
  const WithdrawalSubmitted(this.withdrawal);
  @override
  List<Object?> get props => [withdrawal];
}

class WithdrawalHistoryLoaded extends BankState {
  final List<WithdrawalEntity> withdrawals;
  const WithdrawalHistoryLoaded(this.withdrawals);
  @override
  List<Object?> get props => [withdrawals];
}

class BankError extends BankState {
  final String message;
  const BankError(this.message);
  @override
  List<Object?> get props => [message];
}
