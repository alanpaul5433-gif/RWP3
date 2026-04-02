part of 'sos_bloc.dart';

sealed class SosState extends Equatable {
  const SosState();
  @override
  List<Object?> get props => [];
}

class SosInitial extends SosState { const SosInitial(); }
class SosLoading extends SosState { const SosLoading(); }
class SosProcessing extends SosState { const SosProcessing(); }

class SosAlertSent extends SosState {
  final SosAlertEntity alert;
  const SosAlertSent(this.alert);
  @override
  List<Object?> get props => [alert];
}

class SosHistoryLoaded extends SosState {
  final List<SosAlertEntity> alerts;
  const SosHistoryLoaded(this.alerts);
  @override
  List<Object?> get props => [alerts];
}

class SosError extends SosState {
  final String message;
  const SosError(this.message);
  @override
  List<Object?> get props => [message];
}
