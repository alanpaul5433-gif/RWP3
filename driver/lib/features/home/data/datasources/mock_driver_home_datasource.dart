import 'package:core/core.dart';

class MockDriverHomeDataSource {
  bool _isOnline = false;

  Future<bool> toggleOnline(String driverId, bool online) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _isOnline = online;
    return _isOnline;
  }

  Future<Map<String, int>> getStats(String driverId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'new': 3,
      'ongoing': 1,
      'completed': 142,
      'rejected': 8,
      'cancelled': 12,
    };
  }

  Future<List<BookingEntity>> getIncomingBookings(String driverId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!_isOnline) return [];
    final now = DateTime.now();
    return [
      BookingEntity(
        id: 'bk_incoming_1',
        customerId: 'user_5',
        bookingStatus: BookingStatus.placed,
        pickupLocation: const LocationLatLng(latitude: 37.77, longitude: -122.41, address: '123 Market St, SF'),
        dropLocation: const LocationLatLng(latitude: 37.78, longitude: -122.40, address: '456 Mission St, SF'),
        vehicleTypeId: 'vt_2',
        vehicleTypeName: 'Sedan',
        estimatedFare: 85.0,
        distanceKm: 5.2,
        durationMinutes: 18,
        paymentType: 'cash',
        createdAt: now.subtract(const Duration(minutes: 1)),
        updatedAt: now,
      ),
    ];
  }
}
