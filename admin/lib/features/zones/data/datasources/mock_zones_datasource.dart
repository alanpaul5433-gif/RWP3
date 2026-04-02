import 'package:core/core.dart';

class MockZonesDataSource {
  final List<ZoneEntity> _zones = [
    const ZoneEntity(id: 'z1', name: 'Downtown SF', isActive: true, coordinates: [
      LocationLatLng(latitude: 37.78, longitude: -122.42, address: ''),
      LocationLatLng(latitude: 37.78, longitude: -122.40, address: ''),
      LocationLatLng(latitude: 37.77, longitude: -122.40, address: ''),
      LocationLatLng(latitude: 37.77, longitude: -122.42, address: ''),
    ]),
    const ZoneEntity(id: 'z2', name: 'Mission District', isActive: true, coordinates: [
      LocationLatLng(latitude: 37.76, longitude: -122.42, address: ''),
      LocationLatLng(latitude: 37.76, longitude: -122.41, address: ''),
      LocationLatLng(latitude: 37.75, longitude: -122.41, address: ''),
      LocationLatLng(latitude: 37.75, longitude: -122.42, address: ''),
    ]),
  ];

  Future<List<ZoneEntity>> getZones() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_zones);
  }

  Future<ZoneEntity> createZone(ZoneEntity zone) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newZone = ZoneEntity(
      id: 'z_${DateTime.now().millisecondsSinceEpoch}',
      name: zone.name,
      coordinates: zone.coordinates,
    );
    _zones.add(newZone);
    return newZone;
  }

  Future<void> deleteZone(String zoneId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _zones.removeWhere((z) => z.id == zoneId);
  }
}
