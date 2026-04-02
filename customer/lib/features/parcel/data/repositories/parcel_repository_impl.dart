import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../../domain/repositories/parcel_repository.dart';
import '../datasources/mock_parcel_datasource.dart';

class ParcelRepositoryImpl implements ParcelRepository {
  final MockParcelDataSource dataSource;
  const ParcelRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, ParcelEntity>> createParcelRide({
    required String customerId,
    required LocationLatLng pickup,
    required LocationLatLng drop,
    required String vehicleTypeId,
    required String vehicleTypeName,
    String? parcelImage,
    required String parcelWeight,
    required String parcelDimension,
    required double totalAmount,
    required String paymentType,
  }) async {
    try {
      return Right(await dataSource.createRide(
        customerId: customerId, pickup: pickup, drop: drop,
        vehicleTypeId: vehicleTypeId, vehicleTypeName: vehicleTypeName,
        parcelImage: parcelImage, parcelWeight: parcelWeight,
        parcelDimension: parcelDimension, totalAmount: totalAmount,
        paymentType: paymentType,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, ParcelEntity>> watchRide(String rideId) =>
      dataSource.watchRide(rideId).map((r) => Right<Failure, ParcelEntity>(r));

  @override
  Future<Either<Failure, ParcelEntity>> cancelRide(String rideId, String reason) async {
    try {
      return Right(await dataSource.cancelRide(rideId, reason));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ParcelEntity>>> getRidesByStatus(String customerId, String status) async {
    try {
      return Right(await dataSource.getRidesByStatus(customerId, status));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
