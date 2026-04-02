part of 'location_bloc.dart';

sealed class LocationState extends Equatable {
  const LocationState();
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationObtained extends LocationState {
  final LocationLatLng currentLocation;
  final LocationLatLng? pickup;
  final LocationLatLng? drop;
  final List<LocationLatLng> stops;

  const LocationObtained({
    required this.currentLocation,
    this.pickup,
    this.drop,
    this.stops = const [],
  });

  @override
  List<Object?> get props => [currentLocation, pickup, drop, stops];
}

class RouteCalculating extends LocationState {
  const RouteCalculating();
}

class RouteCalculated extends LocationState {
  final LocationLatLng pickup;
  final LocationLatLng drop;
  final List<LocationLatLng> stops;
  final DistanceEntity distance;

  const RouteCalculated({
    required this.pickup,
    required this.drop,
    this.stops = const [],
    required this.distance,
  });

  @override
  List<Object?> get props => [pickup, drop, stops, distance];
}

class FareEstimated extends LocationState {
  final LocationLatLng pickup;
  final LocationLatLng drop;
  final List<LocationLatLng> stops;
  final DistanceEntity distance;
  final FareEntity fare;
  final VehicleTypeEntity vehicleType;

  const FareEstimated({
    required this.pickup,
    required this.drop,
    this.stops = const [],
    required this.distance,
    required this.fare,
    required this.vehicleType,
  });

  @override
  List<Object?> get props => [pickup, drop, distance, fare, vehicleType];
}

class LocationError extends LocationState {
  final String message;
  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}
