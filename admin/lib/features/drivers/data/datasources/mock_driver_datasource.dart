import 'package:core/core.dart';

class MockDriverDataSource {
  final List<DriverEntity> _drivers = List.generate(
    20,
    (i) => DriverEntity(
      id: 'driver_$i',
      fullName: 'Driver ${i + 1}',
      email: 'driver${i + 1}@example.com',
      phoneNumber: '+1987654${i.toString().padLeft(4, '0')}',
      gender: i % 3 == 0 ? 'Female' : 'Male',
      walletAmount: (i + 1) * 25.0,
      totalEarning: (i + 1) * 500.0,
      reviewsCount: i * 5 + 10,
      reviewsSum: (i * 5 + 10) * (3.5 + (i % 3) * 0.5),
      isActive: true,
      isVerified: i < 15, // first 15 verified, last 5 unverified
      isOnline: i < 8, // first 8 online
      vehicleTypeName: i % 2 == 0 ? 'Economy' : 'Sedan',
      vehicleBrandName: i % 2 == 0 ? 'Toyota' : 'Honda',
      vehicleModelName: i % 2 == 0 ? 'Camry' : 'Civic',
      vehicleNumber: 'ABC ${1000 + i}',
      verifyDocument: [
        DriverDocument(
          documentId: 'license',
          frontImage: 'https://example.com/license_front_$i.jpg',
          backImage: 'https://example.com/license_back_$i.jpg',
          isVerified: i < 15,
        ),
        DriverDocument(
          documentId: 'id_card',
          frontImage: 'https://example.com/id_front_$i.jpg',
          backImage: 'https://example.com/id_back_$i.jpg',
          isVerified: i < 15,
        ),
      ],
      zoneIds: ['zone_1'],
      createdAt: DateTime(2024, 1, 1).add(Duration(days: i)),
      updatedAt: DateTime.now(),
    ),
  );

  Future<List<DriverEntity>> getDrivers({
    bool? isVerified,
    bool? isOnline,
    String? searchQuery,
    int page = 0,
    int pageSize = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var filtered = _drivers.toList();
    if (isVerified != null) {
      filtered = filtered.where((d) => d.isVerified == isVerified).toList();
    }
    if (isOnline != null) {
      filtered = filtered.where((d) => d.isOnline == isOnline).toList();
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      filtered = filtered
          .where((d) =>
              d.fullName.toLowerCase().contains(q) ||
              d.email.toLowerCase().contains(q))
          .toList();
    }
    final start = page * pageSize;
    if (start >= filtered.length) return [];
    final end = (start + pageSize).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  Future<DriverEntity> getDriver(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _drivers.firstWhere(
      (d) => d.id == id,
      orElse: () => throw const ServerException('Driver not found'),
    );
  }

  Future<DriverEntity> verifyDriver(String driverId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _drivers.indexWhere((d) => d.id == driverId);
    if (index == -1) throw const ServerException('Driver not found');

    final existing = _drivers[index];
    final verified = DriverEntity(
      id: existing.id,
      fullName: existing.fullName,
      email: existing.email,
      phoneNumber: existing.phoneNumber,
      isActive: existing.isActive,
      isVerified: true,
      isOnline: existing.isOnline,
      vehicleTypeName: existing.vehicleTypeName,
      vehicleBrandName: existing.vehicleBrandName,
      vehicleModelName: existing.vehicleModelName,
      vehicleNumber: existing.vehicleNumber,
      verifyDocument: existing.verifyDocument
          .map((d) => DriverDocument(
                documentId: d.documentId,
                frontImage: d.frontImage,
                backImage: d.backImage,
                isVerified: true,
              ))
          .toList(),
      zoneIds: existing.zoneIds,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
    _drivers[index] = verified;
    return verified;
  }
}
