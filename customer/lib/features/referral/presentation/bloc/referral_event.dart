part of 'referral_bloc.dart';

sealed class ReferralEvent extends Equatable {
  const ReferralEvent();
  @override
  List<Object?> get props => [];
}

class ReferralCodeRequested extends ReferralEvent {
  final String userId;
  const ReferralCodeRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}
