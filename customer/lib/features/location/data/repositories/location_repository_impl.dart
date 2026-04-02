import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/mock_location_datasource.dart';

class LocationRepositoryImpl implements LocationRepository {
  final MockLocationDataSource dataSource;
  const LocationRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, LocationLatLng>> getCurrentLocation() async {
    try {
      final location = await dataSource.getCurrentLocation();
      return Right(location);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DistanceEntity>> calculateRoute(
    LocationLatLng origin,
    LocationLatLng destination,
    List<LocationLatLng> stops,
  ) async {
    try {
      final distance =
          await dataSource.calculateRoute(origin, destination, stops);
      return Right(distance);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FareEntity>> estimateFare({
    required DistanceEntity distance,
    required VehicleTypeEntity vehicleType,
    double taxPercent = 8,
    double commissionPercent = 20,
    bool isNight = false,
    double nightChargePercent = 15,
  }) async {
    try {
      final fare = await dataSource.estimateFare(
        distance: distance,
        vehicleType: vehicleType,
        taxPercent: taxPercent,
        commissionPercent: commissionPercent,
        isNight: isNight,
        nightChargePercent: nightChargePercent,
      );
      return Right(fare);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
