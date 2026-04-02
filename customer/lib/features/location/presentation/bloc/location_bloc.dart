import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../domain/usecases/get_current_location.dart';
import '../../domain/usecases/calculate_route.dart';
import '../../domain/usecases/estimate_fare.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocation _getCurrentLocation;
  final CalculateRoute _calculateRoute;
  final EstimateFare _estimateFare;

  LocationBloc({
    required GetCurrentLocation getCurrentLocation,
    required CalculateRoute calculateRoute,
    required EstimateFare estimateFare,
  })  : _getCurrentLocation = getCurrentLocation,
        _calculateRoute = calculateRoute,
        _estimateFare = estimateFare,
        super(const LocationInitial()) {
    on<CurrentLocationRequested>(_onCurrentLocationRequested);
    on<PickupLocationSet>(_onPickupLocationSet);
    on<DropLocationSet>(_onDropLocationSet);
    on<StopAdded>(_onStopAdded);
    on<StopRemoved>(_onStopRemoved);
    on<RouteCalculationRequested>(_onRouteCalculationRequested);
    on<FareEstimationRequested>(_onFareEstimationRequested);
    on<LocationReset>(_onLocationReset);
  }

  LocationLatLng? _pickup;
  LocationLatLng? _drop;
  final List<LocationLatLng> _stops = [];
  DistanceEntity? _lastDistance;

  Future<void> _onCurrentLocationRequested(
    CurrentLocationRequested event,
    Emitter<LocationState> emit,
  ) async {
    final result = await _getCurrentLocation(const NoParams());
    result.fold(
      (failure) => emit(LocationError(mapFailureToMessage(failure))),
      (location) {
        _pickup = location;
        emit(LocationObtained(
          currentLocation: location,
          pickup: _pickup,
          drop: _drop,
          stops: List.unmodifiable(_stops),
        ));
      },
    );
  }

  void _onPickupLocationSet(
    PickupLocationSet event,
    Emitter<LocationState> emit,
  ) {
    _pickup = event.location;
    emit(LocationObtained(
      currentLocation: _pickup!,
      pickup: _pickup,
      drop: _drop,
      stops: List.unmodifiable(_stops),
    ));
  }

  void _onDropLocationSet(
    DropLocationSet event,
    Emitter<LocationState> emit,
  ) {
    _drop = event.location;
    emit(LocationObtained(
      currentLocation: _pickup ?? const LocationLatLng.empty(),
      pickup: _pickup,
      drop: _drop,
      stops: List.unmodifiable(_stops),
    ));
  }

  void _onStopAdded(StopAdded event, Emitter<LocationState> emit) {
    _stops.add(event.location);
    emit(LocationObtained(
      currentLocation: _pickup ?? const LocationLatLng.empty(),
      pickup: _pickup,
      drop: _drop,
      stops: List.unmodifiable(_stops),
    ));
  }

  void _onStopRemoved(StopRemoved event, Emitter<LocationState> emit) {
    if (event.index >= 0 && event.index < _stops.length) {
      _stops.removeAt(event.index);
    }
    emit(LocationObtained(
      currentLocation: _pickup ?? const LocationLatLng.empty(),
      pickup: _pickup,
      drop: _drop,
      stops: List.unmodifiable(_stops),
    ));
  }

  Future<void> _onRouteCalculationRequested(
    RouteCalculationRequested event,
    Emitter<LocationState> emit,
  ) async {
    if (_pickup == null || _drop == null) {
      emit(const LocationError('Please set pickup and drop locations'));
      return;
    }
    emit(const RouteCalculating());
    final result = await _calculateRoute(CalculateRouteParams(
      origin: _pickup!,
      destination: _drop!,
      stops: _stops,
    ));
    result.fold(
      (failure) => emit(LocationError(mapFailureToMessage(failure))),
      (distance) {
        _lastDistance = distance;
        emit(RouteCalculated(
          pickup: _pickup!,
          drop: _drop!,
          stops: List.unmodifiable(_stops),
          distance: distance,
        ));
      },
    );
  }

  Future<void> _onFareEstimationRequested(
    FareEstimationRequested event,
    Emitter<LocationState> emit,
  ) async {
    if (_lastDistance == null) {
      emit(const LocationError('Calculate route first'));
      return;
    }
    final result = await _estimateFare(EstimateFareParams(
      distance: _lastDistance!,
      vehicleType: event.vehicleType,
    ));
    result.fold(
      (failure) => emit(LocationError(mapFailureToMessage(failure))),
      (fare) => emit(FareEstimated(
        pickup: _pickup!,
        drop: _drop!,
        stops: List.unmodifiable(_stops),
        distance: _lastDistance!,
        fare: fare,
        vehicleType: event.vehicleType,
      )),
    );
  }

  void _onLocationReset(LocationReset event, Emitter<LocationState> emit) {
    _pickup = null;
    _drop = null;
    _stops.clear();
    _lastDistance = null;
    emit(const LocationInitial());
  }
}
