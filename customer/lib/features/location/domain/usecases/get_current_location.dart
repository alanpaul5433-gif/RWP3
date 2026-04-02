import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../repositories/location_repository.dart';

class GetCurrentLocation implements UseCase<LocationLatLng, NoParams> {
  final LocationRepository repository;
  const GetCurrentLocation(this.repository);

  @override
  Future<Either<Failure, LocationLatLng>> call(NoParams params) {
    return repository.getCurrentLocation();
  }
}
