import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../repositories/vehicle_repository.dart';

class GetVehicleTypes implements UseCase<List<VehicleTypeEntity>, NoParams> {
  final VehicleRepository repository;
  const GetVehicleTypes(this.repository);

  @override
  Future<Either<Failure, List<VehicleTypeEntity>>> call(NoParams params) {
    return repository.getVehicleTypes();
  }
}
