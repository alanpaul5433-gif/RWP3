import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:core/core.dart';
import '../repositories/location_repository.dart';

class CalculateRoute implements UseCase<DistanceEntity, CalculateRouteParams> {
  final LocationRepository repository;
  const CalculateRoute(this.repository);

  @override
  Future<Either<Failure, DistanceEntity>> call(CalculateRouteParams params) {
    return repository.calculateRoute(
      params.origin,
      params.destination,
      params.stops,
    );
  }
}

class CalculateRouteParams extends Equatable {
  final LocationLatLng origin;
  final LocationLatLng destination;
  final List<LocationLatLng> stops;

  const CalculateRouteParams({
    required this.origin,
    required this.destination,
    this.stops = const [],
  });

  @override
  List<Object?> get props => [origin, destination, stops];
}
