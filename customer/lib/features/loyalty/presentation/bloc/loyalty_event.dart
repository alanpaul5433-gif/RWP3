part of 'loyalty_bloc.dart';

sealed class LoyaltyEvent extends Equatable {
  const LoyaltyEvent();
  @override
  List<Object?> get props => [];
}

class LoyaltyLoadRequested extends LoyaltyEvent {
  final String userId;
  const LoyaltyLoadRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}
