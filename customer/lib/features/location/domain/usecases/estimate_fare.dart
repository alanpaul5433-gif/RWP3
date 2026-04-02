import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:core/core.dart';
import '../repositories/location_repository.dart';

class EstimateFare implements UseCase<FareEntity, EstimateFareParams> {
  final LocationRepository repository;
  const EstimateFare(this.repository);

  @override
  Future<Either<Failure, FareEntity>> call(EstimateFareParams params) {
    return repository.estimateFare(
      distance: params.distance,
      vehicleType: params.vehicleType,
      taxPercent: params.taxPercent,
      commissionPercent: params.commissionPercent,
      isNight: params.isNight,
      nightChargePercent: params.nightChargePercent,
    );
  }
}

class EstimateFareParams extends Equatable {
  final DistanceEntity distance;
  final VehicleTypeEntity vehicleType;
  final double taxPercent;
  final double commissionPercent;
  final bool isNight;
  final double nightChargePercent;

  const EstimateFareParams({
    required this.distance,
    required this.vehicleType,
    this.taxPercent = 8,
    this.commissionPercent = 20,
    this.isNight = false,
    this.nightChargePercent = 15,
  });

  @override
  List<Object?> get props =>
      [distance, vehicleType, taxPercent, commissionPercent];
}
