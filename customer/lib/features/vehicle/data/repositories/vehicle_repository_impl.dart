import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/mock_vehicle_datasource.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final MockVehicleDataSource dataSource;
  const VehicleRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<VehicleTypeEntity>>> getVehicleTypes() async {
    try {
      final types = await dataSource.getVehicleTypes();
      return Right(types);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
