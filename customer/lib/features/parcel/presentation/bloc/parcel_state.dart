part of 'parcel_bloc.dart';

sealed class ParcelState extends Equatable {
  const ParcelState();
  @override
  List<Object?> get props => [];
}

class ParcelInitial extends ParcelState { const ParcelInitial(); }
class ParcelCreating extends ParcelState { const ParcelCreating(); }

class ParcelPlaced extends ParcelState {
  final ParcelEntity ride;
  const ParcelPlaced(this.ride);
  @override
  List<Object?> get props => [ride];
}

class ParcelUpdated extends ParcelState {
  final ParcelEntity ride;
  const ParcelUpdated(this.ride);
  @override
  List<Object?> get props => [ride];
}

class ParcelCancelled extends ParcelState {
  final ParcelEntity ride;
  const ParcelCancelled(this.ride);
  @override
  List<Object?> get props => [ride];
}

class ParcelHistoryLoaded extends ParcelState {
  final List<ParcelEntity> rides;
  const ParcelHistoryLoaded(this.rides);
  @override
  List<Object?> get props => [rides];
}

class ParcelError extends ParcelState {
  final String message;
  const ParcelError(this.message);
  @override
  List<Object?> get props => [message];
}
