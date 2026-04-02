part of 'location_bloc.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();
  @override
  List<Object?> get props => [];
}

class CurrentLocationRequested extends LocationEvent {
  const CurrentLocationRequested();
}

class PickupLocationSet extends LocationEvent {
  final LocationLatLng location;
  const PickupLocationSet(this.location);
  @override
  List<Object?> get props => [location];
}

class DropLocationSet extends LocationEvent {
  final LocationLatLng location;
  const DropLocationSet(this.location);
  @override
  List<Object?> get props => [location];
}

class StopAdded extends LocationEvent {
  final LocationLatLng location;
  const StopAdded(this.location);
  @override
  List<Object?> get props => [location];
}

class StopRemoved extends LocationEvent {
  final int index;
  const StopRemoved(this.index);
  @override
  List<Object?> get props => [index];
}

class RouteCalculationRequested extends LocationEvent {
  const RouteCalculationRequested();
}

class FareEstimationRequested extends LocationEvent {
  final VehicleTypeEntity vehicleType;
  const FareEstimationRequested(this.vehicleType);
  @override
  List<Object?> get props => [vehicleType];
}

class LocationReset extends LocationEvent {
  const LocationReset();
}
