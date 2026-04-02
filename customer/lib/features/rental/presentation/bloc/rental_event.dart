part of 'rental_bloc.dart';

sealed class RentalEvent extends Equatable {
  const RentalEvent();
  @override
  List<Object?> get props => [];
}

class RentalPackagesRequested extends RentalEvent {
  const RentalPackagesRequested();
}

class RentalCreateRequested extends RentalEvent {
  final String customerId;
  final LocationLatLng pickup;
  final String vehicleTypeId;
  final String vehicleTypeName;
  final RentalPackage package;
  final String paymentType;

  const RentalCreateRequested({
    required this.customerId, required this.pickup,
    required this.vehicleTypeId, this.vehicleTypeName = '',
    required this.package, required this.paymentType,
  });

  @override
  List<Object?> get props => [customerId, pickup, vehicleTypeId, package];
}

class RentalWatchRequested extends RentalEvent {
  final String rideId;
  const RentalWatchRequested(this.rideId);
  @override
  List<Object?> get props => [rideId];
}

class RentalCancelRequested extends RentalEvent {
  final String rideId;
  final String reason;
  const RentalCancelRequested({required this.rideId, required this.reason});
  @override
  List<Object?> get props => [rideId, reason];
}

class RentalHistoryRequested extends RentalEvent {
  final String customerId;
  final String status;
  const RentalHistoryRequested({required this.customerId, required this.status});
  @override
  List<Object?> get props => [customerId, status];
}
