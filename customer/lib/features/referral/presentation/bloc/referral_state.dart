part of 'referral_bloc.dart';

sealed class ReferralState extends Equatable {
  const ReferralState();
  @override
  List<Object?> get props => [];
}

class ReferralInitial extends ReferralState { const ReferralInitial(); }
class ReferralLoading extends ReferralState { const ReferralLoading(); }

class ReferralCodeLoaded extends ReferralState {
  final String code;
  const ReferralCodeLoaded(this.code);
  @override
  List<Object?> get props => [code];
}

class ReferralError extends ReferralState {
  final String message;
  const ReferralError(this.message);
  @override
  List<Object?> get props => [message];
}
