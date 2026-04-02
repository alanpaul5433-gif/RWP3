part of 'subscriptions_bloc.dart';

sealed class SubscriptionsState extends Equatable {
  const SubscriptionsState();
  @override
  List<Object?> get props => [];
}

class SubscriptionsInitial extends SubscriptionsState { const SubscriptionsInitial(); }
class SubscriptionsLoading extends SubscriptionsState { const SubscriptionsLoading(); }

class SubscriptionsLoaded extends SubscriptionsState {
  final List<SubscriptionPlanEntity> plans;
  const SubscriptionsLoaded(this.plans);
  @override
  List<Object?> get props => [plans];
}

class SubscriptionsError extends SubscriptionsState {
  final String message;
  const SubscriptionsError(this.message);
  @override
  List<Object?> get props => [message];
}
