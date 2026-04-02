import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

abstract class ParcelRepository {
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
  });
  Stream<Either<Failure, ParcelEntity>> watchRide(String rideId);
  Future<Either<Failure, ParcelEntity>> cancelRide(String rideId, String reason);
  Future<Either<Failure, List<ParcelEntity>>> getRidesByStatus(String customerId, String status);
}
