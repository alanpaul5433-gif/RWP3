part of 'rental_bloc.dart';

sealed class RentalState extends Equatable {
  const RentalState();
  @override
  List<Object?> get props => [];
}

class RentalInitial extends RentalState { const RentalInitial(); }
class RentalLoading extends RentalState { const RentalLoading(); }
class RentalCreating extends RentalState { const RentalCreating(); }

class RentalPackagesLoaded extends RentalState {
  final List<RentalPackage> packages;
  const RentalPackagesLoaded(this.packages);
  @override
  List<Object?> get props => [packages];
}

class RentalPlaced extends RentalState {
  final RentalEntity ride;
  const RentalPlaced(this.ride);
  @override
  List<Object?> get props => [ride];
}

class RentalUpdated extends RentalState {
  final RentalEntity ride;
  const RentalUpdated(this.ride);
  @override
  List<Object?> get props => [ride];
}

class RentalCancelled extends RentalState {
  final RentalEntity ride;
  const RentalCancelled(this.ride);
  @override
  List<Object?> get props => [ride];
}

class RentalHistoryLoaded extends RentalState {
  final List<RentalEntity> rides;
  const RentalHistoryLoaded(this.rides);
  @override
  List<Object?> get props => [rides];
}

class RentalError extends RentalState {
  final String message;
  const RentalError(this.message);
  @override
  List<Object?> get props => [message];
}
