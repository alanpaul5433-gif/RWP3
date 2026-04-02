part of 'intercity_bloc.dart';

sealed class IntercityState extends Equatable {
  const IntercityState();
  @override
  List<Object?> get props => [];
}

class IntercityInitial extends IntercityState { const IntercityInitial(); }
class IntercityCreating extends IntercityState { const IntercityCreating(); }

class IntercityPlaced extends IntercityState {
  final IntercityEntity ride;
  const IntercityPlaced(this.ride);
  @override
  List<Object?> get props => [ride];
}

class IntercityUpdated extends IntercityState {
  final IntercityEntity ride;
  const IntercityUpdated(this.ride);
  @override
  List<Object?> get props => [ride];
}

class IntercityCancelled extends IntercityState {
  final IntercityEntity ride;
  const IntercityCancelled(this.ride);
  @override
  List<Object?> get props => [ride];
}

class IntercityHistoryLoaded extends IntercityState {
  final List<IntercityEntity> rides;
  const IntercityHistoryLoaded(this.rides);
  @override
  List<Object?> get props => [rides];
}

class IntercityError extends IntercityState {
  final String message;
  const IntercityError(this.message);
  @override
  List<Object?> get props => [message];
}
