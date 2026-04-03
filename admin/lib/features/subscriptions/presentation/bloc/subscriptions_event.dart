part of 'subscriptions_bloc.dart';

sealed class SubscriptionsEvent extends Equatable {
  const SubscriptionsEvent();
  @override
  List<Object?> get props => [];
}

class SubscriptionsLoadRequested extends SubscriptionsEvent { const SubscriptionsLoadRequested(); }

class SubscriptionCreateRequested extends SubscriptionsEvent {
  final SubscriptionPlanEntity plan;
  const SubscriptionCreateRequested(this.plan);
  @override
  List<Object?> get props => [plan];
}

class SubscriptionUpdateRequested extends SubscriptionsEvent {
  final SubscriptionPlanEntity plan;
  const SubscriptionUpdateRequested(this.plan);
  @override
  List<Object?> get props => [plan];
}

class SubscriptionDeleteRequested extends SubscriptionsEvent {
  final String planId;
  const SubscriptionDeleteRequested(this.planId);
  @override
  List<Object?> get props => [planId];
}
