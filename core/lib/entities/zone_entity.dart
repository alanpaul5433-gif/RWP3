import 'package:equatable/equatable.dart';
import 'location_latlng.dart';

class ZoneEntity extends Equatable {
  final String id;
  final String name;
  final List<LocationLatLng> coordinates;
  final bool isActive;

  const ZoneEntity({
    required this.id,
    required this.name,
    this.coordinates = const [],
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, isActive];
}
