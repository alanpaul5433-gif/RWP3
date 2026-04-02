import 'package:core/core.dart';

class MockVehicleDataSource {
  Future<List<VehicleTypeEntity>> getVehicleTypes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      VehicleTypeEntity(
        id: 'vt_1',
        name: 'Economy',
        persons: 4,
        baseFare: 30,
        perKmRate: 10,
        perMinuteRate: 1.5,
        minimumFare: 50,
      ),
      VehicleTypeEntity(
        id: 'vt_2',
        name: 'Sedan',
        persons: 4,
        baseFare: 50,
        perKmRate: 14,
        perMinuteRate: 2,
        minimumFare: 80,
      ),
      VehicleTypeEntity(
        id: 'vt_3',
        name: 'SUV',
        persons: 6,
        baseFare: 80,
        perKmRate: 18,
        perMinuteRate: 2.5,
        minimumFare: 120,
      ),
      VehicleTypeEntity(
        id: 'vt_4',
        name: 'Premium',
        persons: 4,
        baseFare: 100,
        perKmRate: 22,
        perMinuteRate: 3,
        minimumFare: 150,
      ),
    ];
  }
}
