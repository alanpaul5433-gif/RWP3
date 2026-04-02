import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../../domain/repositories/intercity_repository.dart';
import '../datasources/mock_intercity_datasource.dart';

class IntercityRepositoryImpl implements IntercityRepository {
  final MockIntercityDataSource dataSource;
  const IntercityRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, IntercityEntity>> createIntercityRide({
    required String customerId,
    required LocationLatLng source,
    required LocationLatLng destination,
    required List<LocationLatLng> stops,
    required String vehicleTypeId,
    required String vehicleTypeName,
    required String rideType,
    required List<SharingPerson> sharingPersons,
    required double totalAmount,
    required String paymentType,
  }) async {
    try {
      final ride = await dataSource.createRide(
        customerId: customerId,
        source: source,
        destination: destination,
        stops: stops,
        vehicleTypeId: vehicleTypeId,
        vehicleTypeName: vehicleTypeName,
        rideType: rideType,
        sharingPersons: sharingPersons,
        totalAmount: totalAmount,
        paymentType: paymentType,
      );
      return Right(ride);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, IntercityEntity>> watchRide(String rideId) {
    return dataSource.watchRide(rideId).map(
          (ride) => Right<Failure, IntercityEntity>(ride),
        );
  }

  @override
  Future<Either<Failure, IntercityEntity>> cancelRide(String rideId, String reason) async {
    try {
      return Right(await dataSource.cancelRide(rideId, reason));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<IntercityEntity>>> getRidesByStatus(String customerId, String status) async {
    try {
      return Right(await dataSource.getRidesByStatus(customerId, status));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
