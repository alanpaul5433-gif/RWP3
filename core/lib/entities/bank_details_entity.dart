import 'package:equatable/equatable.dart';

class BankDetailsEntity extends Equatable {
  final String id;
  final String driverId;
  final String holderName;
  final String accountNumber;
  final String swiftCode;
  final String ifscCode;
  final String bankName;
  final String branchCity;
  final String branchCountry;
  final bool isDefault;

  const BankDetailsEntity({
    required this.id,
    required this.driverId,
    required this.holderName,
    required this.accountNumber,
    this.swiftCode = '',
    this.ifscCode = '',
    required this.bankName,
    this.branchCity = '',
    this.branchCountry = '',
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, driverId, accountNumber];
}

class WithdrawalEntity extends Equatable {
  final String id;
  final String driverId;
  final double amount;
  final String status; // pending, approved, rejected
  final BankDetailsEntity bankDetails;
  final DateTime createdAt;

  const WithdrawalEntity({
    required this.id,
    required this.driverId,
    required this.amount,
    this.status = 'pending',
    required this.bankDetails,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, driverId, amount, status];
}
