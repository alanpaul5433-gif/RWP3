import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

abstract class LocationRepository {
  Future<Either<Failure, LocationLatLng>> getCurrentLocation();
  Future<Either<Failure, DistanceEntity>> calculateRoute(
    LocationLatLng origin,
    LocationLatLng destination,
    List<LocationLatLng> stops,
  );
  Future<Either<Failure, FareEntity>> estimateFare({
    required DistanceEntity distance,
    required VehicleTypeEntity vehicleType,
    double taxPercent,
    double commissionPercent,
    bool isNight,
    double nightChargePercent,
  });
}
