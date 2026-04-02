import 'package:equatable/equatable.dart';

class VehicleTypeEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final bool isActive;
  final int persons;
  final double baseFare;
  final double perKmRate;
  final double perMinuteRate;
  final double minimumFare;

  const VehicleTypeEntity({
    required this.id,
    required this.name,
    this.image = '',
    this.isActive = true,
    this.persons = 4,
    required this.baseFare,
    required this.perKmRate,
    required this.perMinuteRate,
    required this.minimumFare,
  });

  @override
  List<Object?> get props => [id, name];
}
