import 'package:equatable/equatable.dart';

class DistanceEntity extends Equatable {
  final double distanceInMeters;
  final double distanceInKm;
  final double durationInMinutes;

  const DistanceEntity({
    required this.distanceInMeters,
    required this.distanceInKm,
    required this.durationInMinutes,
  });

  const DistanceEntity.empty()
      : distanceInMeters = 0,
        distanceInKm = 0,
        durationInMinutes = 0;

  @override
  List<Object?> get props => [distanceInMeters, distanceInKm, durationInMinutes];
}
