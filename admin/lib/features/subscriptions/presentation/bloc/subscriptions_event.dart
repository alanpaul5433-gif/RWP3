part of 'subscriptions_bloc.dart';

sealed class SubscriptionsEvent extends Equatable {
  const SubscriptionsEvent();
  @override
  List<Object?> get props => [];
}

class SubscriptionsLoadRequested extends SubscriptionsEvent { const SubscriptionsLoadRequested(); }
