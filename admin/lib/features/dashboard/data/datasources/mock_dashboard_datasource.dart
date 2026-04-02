import 'package:core/core.dart';

class MockDashboardDataSource {
  Future<DashboardStatsEntity> getStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const DashboardStatsEntity(
      totalCustomers: 1250,
      totalDrivers: 340,
      totalBookings: 8750,
      activeBookings: 42,
      completedBookings: 8200,
      cancelledBookings: 508,
      todayEarnings: 4520.50,
      monthlyEarnings: 125600.00,
    );
  }

  Future<List<UserEntity>> getRecentCustomers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    return List.generate(
      5,
      (i) => UserEntity(
        id: 'user_$i',
        fullName: 'Customer ${i + 1}',
        email: 'customer${i + 1}@example.com',
        phoneNumber: '+1234567${i}890',
        createdAt: now.subtract(Duration(hours: i)),
        updatedAt: now,
      ),
    );
  }

  Future<List<BookingEntity>> getRecentBookings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    final statuses = [
      BookingStatus.completed,
      BookingStatus.ongoing,
      BookingStatus.placed,
      BookingStatus.cancelled,
      BookingStatus.completed,
    ];
    return List.generate(
      5,
      (i) => BookingEntity(
        id: 'bk_recent_$i',
        customerId: 'user_$i',
        bookingStatus: statuses[i],
        pickupLocation: const LocationLatLng(
          latitude: 37.77,
          longitude: -122.41,
          address: 'Market St, SF',
        ),
        dropLocation: const LocationLatLng(
          latitude: 37.78,
          longitude: -122.40,
          address: 'Mission St, SF',
        ),
        vehicleTypeId: 'vt_1',
        vehicleTypeName: 'Economy',
        totalAmount: 35.0 + (i * 15),
        createdAt: now.subtract(Duration(minutes: i * 30)),
        updatedAt: now,
      ),
    );
  }
}
