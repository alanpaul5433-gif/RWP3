import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

abstract class IntercityRepository {
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
  });
  Stream<Either<Failure, IntercityEntity>> watchRide(String rideId);
  Future<Either<Failure, IntercityEntity>> cancelRide(String rideId, String reason);
  Future<Either<Failure, List<IntercityEntity>>> getRidesByStatus(String customerId, String status);
}
