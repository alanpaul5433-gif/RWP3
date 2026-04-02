import 'package:equatable/equatable.dart';

class WalletTransactionEntity extends Equatable {
  final String id;
  final String userId;
  final double amount;
  final String type; // credit, debit
  final String note;
  final String? transactionId;
  final DateTime createdAt;

  const WalletTransactionEntity({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    this.note = '',
    this.transactionId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, amount, type];
}
