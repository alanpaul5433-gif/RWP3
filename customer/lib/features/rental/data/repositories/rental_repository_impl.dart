import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../../domain/repositories/rental_repository.dart';
import '../datasources/mock_rental_datasource.dart';

class RentalRepositoryImpl implements RentalRepository {
  final MockRentalDataSource dataSource;
  const RentalRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<RentalPackage>>> getRentalPackages() async {
    try {
      return Right(await dataSource.getRentalPackages());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RentalEntity>> createRentalRide({
    required String customerId,
    required LocationLatLng pickup,
    required String vehicleTypeId,
    required String vehicleTypeName,
    required RentalPackage package,
    required String paymentType,
  }) async {
    try {
      return Right(await dataSource.createRide(
        customerId: customerId, pickup: pickup,
        vehicleTypeId: vehicleTypeId, vehicleTypeName: vehicleTypeName,
        package: package, paymentType: paymentType,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, RentalEntity>> watchRide(String rideId) =>
      dataSource.watchRide(rideId).map((r) => Right<Failure, RentalEntity>(r));

  @override
  Future<Either<Failure, RentalEntity>> cancelRide(String rideId, String reason) async {
    try {
      return Right(await dataSource.cancelRide(rideId, reason));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RentalEntity>>> getRidesByStatus(String customerId, String status) async {
    try {
      return Right(await dataSource.getRidesByStatus(customerId, status));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
