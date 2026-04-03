import 'package:equatable/equatable.dart';
import 'location_latlng.dart';

class ZoneEntity extends Equatable {
  final String id;
  final String name;
  final List<LocationLatLng> coordinates;
  final LocationLatLng? center;
  final double radiusKm;
  final String type; // 'polygon' or 'circle'
  final bool isActive;

  const ZoneEntity({
    required this.id,
    required this.name,
    this.coordinates = const [],
    this.center,
    this.radiusKm = 10.0,
    this.type = 'circle',
    this.isActive = true,
  });

  ZoneEntity copyWith({
    String? id, String? name, List<LocationLatLng>? coordinates,
    LocationLatLng? center, double? radiusKm, String? type, bool? isActive,
  }) => ZoneEntity(
    id: id ?? this.id, name: name ?? this.name,
    coordinates: coordinates ?? this.coordinates, center: center ?? this.center,
    radiusKm: radiusKm ?? this.radiusKm, type: type ?? this.type,
    isActive: isActive ?? this.isActive,
  );

  @override
  List<Object?> get props => [id, name, isActive, radiusKm, type];
}
