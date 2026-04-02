part of 'loyalty_bloc.dart';

sealed class LoyaltyState extends Equatable {
  const LoyaltyState();
  @override
  List<Object?> get props => [];
}

class LoyaltyInitial extends LoyaltyState { const LoyaltyInitial(); }
class LoyaltyLoading extends LoyaltyState { const LoyaltyLoading(); }

class LoyaltyLoaded extends LoyaltyState {
  final double credits;
  final List<LoyaltyPointTransactionEntity> transactions;
  const LoyaltyLoaded({required this.credits, required this.transactions});
  @override
  List<Object?> get props => [credits, transactions];
}

class LoyaltyError extends LoyaltyState {
  final String message;
  const LoyaltyError(this.message);
  @override
  List<Object?> get props => [message];
}
