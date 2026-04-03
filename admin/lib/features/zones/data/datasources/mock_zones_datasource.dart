import 'package:core/core.dart';

class MockZonesDataSource {
  final List<ZoneEntity> _zones = [
    const ZoneEntity(id: 'z1', name: 'Downtown SF', center: LocationLatLng(latitude: 37.7749, longitude: -122.4194), radiusKm: 8.0, type: 'circle'),
    const ZoneEntity(id: 'z2', name: 'Airport Zone', center: LocationLatLng(latitude: 37.6213, longitude: -122.3790), radiusKm: 5.0, type: 'circle'),
    const ZoneEntity(id: 'z3', name: 'East Bay', center: LocationLatLng(latitude: 37.8044, longitude: -122.2712), radiusKm: 12.0, type: 'circle', isActive: false),
  ];

  Future<List<ZoneEntity>> getZones() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_zones);
  }

  Future<ZoneEntity> createZone(ZoneEntity zone) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newZone = ZoneEntity(
      id: 'z_${DateTime.now().millisecondsSinceEpoch}',
      name: zone.name, center: zone.center, radiusKm: zone.radiusKm,
      type: zone.type, coordinates: zone.coordinates,
    );
    _zones.add(newZone);
    return newZone;
  }

  Future<void> deleteZone(String zoneId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _zones.removeWhere((z) => z.id == zoneId);
  }

  Future<void> toggleZone(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final idx = _zones.indexWhere((z) => z.id == id);
    if (idx >= 0) {
      final z = _zones[idx];
      _zones[idx] = z.copyWith(isActive: !z.isActive);
    }
  }
}
