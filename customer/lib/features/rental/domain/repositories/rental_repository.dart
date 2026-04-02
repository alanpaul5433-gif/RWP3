import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

abstract class RentalRepository {
  Future<Either<Failure, List<RentalPackage>>> getRentalPackages();
  Future<Either<Failure, RentalEntity>> createRentalRide({
    required String customerId,
    required LocationLatLng pickup,
    required String vehicleTypeId,
    required String vehicleTypeName,
    required RentalPackage package,
    required String paymentType,
  });
  Stream<Either<Failure, RentalEntity>> watchRide(String rideId);
  Future<Either<Failure, RentalEntity>> cancelRide(String rideId, String reason);
  Future<Either<Failure, List<RentalEntity>>> getRidesByStatus(String customerId, String status);
}
