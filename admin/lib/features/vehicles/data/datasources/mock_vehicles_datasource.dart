import 'package:core/core.dart';

class MockVehiclesDataSource {
  final List<VehicleTypeEntity> _types = [
    const VehicleTypeEntity(id: 'vt_1', name: 'Economy Sedan', persons: 4, baseFare: 3.00, perKmRate: 1.50, perMinuteRate: 0.25, minimumFare: 5.00),
    const VehicleTypeEntity(id: 'vt_2', name: 'Premium Sedan', persons: 4, baseFare: 5.00, perKmRate: 2.50, perMinuteRate: 0.40, minimumFare: 8.00),
    const VehicleTypeEntity(id: 'vt_3', name: 'SUV', persons: 6, baseFare: 7.00, perKmRate: 3.00, perMinuteRate: 0.50, minimumFare: 12.00),
    const VehicleTypeEntity(id: 'vt_4', name: 'Luxury', persons: 4, baseFare: 10.00, perKmRate: 4.50, perMinuteRate: 0.75, minimumFare: 18.00),
  ];

  final List<Map<String, String>> _brands = [
    {'id': 'b_1', 'name': 'Toyota', 'type': 'vt_1'},
    {'id': 'b_2', 'name': 'Honda', 'type': 'vt_1'},
    {'id': 'b_3', 'name': 'Mercedes-Benz', 'type': 'vt_2'},
    {'id': 'b_4', 'name': 'BMW', 'type': 'vt_2'},
    {'id': 'b_5', 'name': 'Ford', 'type': 'vt_3'},
    {'id': 'b_6', 'name': 'Lexus', 'type': 'vt_4'},
  ];

  Future<List<VehicleTypeEntity>> getVehicleTypes() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_types);
  }

  Future<VehicleTypeEntity> createVehicleType(VehicleTypeEntity type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newType = VehicleTypeEntity(
      id: 'vt_${DateTime.now().millisecondsSinceEpoch}',
      name: type.name, persons: type.persons,
      baseFare: type.baseFare, perKmRate: type.perKmRate,
      perMinuteRate: type.perMinuteRate, minimumFare: type.minimumFare,
    );
    _types.add(newType);
    return newType;
  }

  Future<VehicleTypeEntity> updateVehicleType(VehicleTypeEntity type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _types.indexWhere((t) => t.id == type.id);
    if (idx >= 0) _types[idx] = type;
    return type;
  }

  Future<void> deleteVehicleType(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _types.removeWhere((t) => t.id == id);
  }

  Future<List<Map<String, String>>> getBrands() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_brands);
  }

  Future<void> createBrand(String name, String typeId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _brands.add({'id': 'b_${DateTime.now().millisecondsSinceEpoch}', 'name': name, 'type': typeId});
  }

  Future<void> deleteBrand(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _brands.removeWhere((b) => b['id'] == id);
  }
}
