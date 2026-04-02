import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

abstract class VehicleRepository {
  Future<Either<Failure, List<VehicleTypeEntity>>> getVehicleTypes();
}
