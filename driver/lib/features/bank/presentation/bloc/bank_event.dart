part of 'bank_bloc.dart';

sealed class BankEvent extends Equatable {
  const BankEvent();
  @override
  List<Object?> get props => [];
}

class BankAccountsLoadRequested extends BankEvent {
  final String driverId;
  const BankAccountsLoadRequested(this.driverId);
  @override
  List<Object?> get props => [driverId];
}

class BankAccountAddRequested extends BankEvent {
  final String driverId;
  final String holderName;
  final String accountNumber;
  final String bankName;
  final String ifscCode;
  final String swiftCode;
  const BankAccountAddRequested({required this.driverId, required this.holderName, required this.accountNumber, required this.bankName, this.ifscCode = '', this.swiftCode = ''});
  @override
  List<Object?> get props => [driverId, accountNumber];
}

class BankAccountDeleteRequested extends BankEvent {
  final String bankId;
  final String driverId;
  const BankAccountDeleteRequested({required this.bankId, required this.driverId});
  @override
  List<Object?> get props => [bankId];
}

class WithdrawalRequested extends BankEvent {
  final String driverId;
  final double amount;
  final String bankId;
  const WithdrawalRequested({required this.driverId, required this.amount, required this.bankId});
  @override
  List<Object?> get props => [driverId, amount, bankId];
}

class WithdrawalHistoryRequested extends BankEvent {
  final String driverId;
  const WithdrawalHistoryRequested(this.driverId);
  @override
  List<Object?> get props => [driverId];
}
