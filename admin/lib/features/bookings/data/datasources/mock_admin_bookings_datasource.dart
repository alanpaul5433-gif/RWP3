import 'package:core/core.dart';

class MockAdminBookingsDataSource {
  final List<BookingEntity> _bookings = List.generate(
    30,
    (i) {
      final statuses = [BookingStatus.completed, BookingStatus.ongoing, BookingStatus.placed, BookingStatus.cancelled, BookingStatus.accepted];
      return BookingEntity(
        id: 'bk_admin_$i',
        customerId: 'user_${i % 10}',
        driverId: i % 3 == 0 ? null : 'driver_${i % 5}',
        bookingStatus: statuses[i % statuses.length],
        pickupLocation: const LocationLatLng(latitude: 37.77, longitude: -122.41, address: 'Market St, SF'),
        dropLocation: const LocationLatLng(latitude: 37.78, longitude: -122.40, address: 'Mission St, SF'),
        vehicleTypeId: 'vt_${i % 4}',
        vehicleTypeName: ['Economy', 'Sedan', 'SUV', 'Premium'][i % 4],
        estimatedFare: 30.0 + (i * 5),
        totalAmount: 30.0 + (i * 5),
        paymentType: i % 2 == 0 ? 'cash' : 'stripe',
        createdAt: DateTime.now().subtract(Duration(hours: i * 3)),
        updatedAt: DateTime.now(),
      );
    },
  );

  Future<List<BookingEntity>> getBookings({String? status, int page = 0, int pageSize = 10}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    var filtered = _bookings.toList();
    if (status != null && status.isNotEmpty) {
      filtered = filtered.where((b) => b.bookingStatus == status).toList();
    }
    final start = page * pageSize;
    if (start >= filtered.length) return [];
    final end = (start + pageSize).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  Future<int> getCount({String? status}) async {
    if (status == null) return _bookings.length;
    return _bookings.where((b) => b.bookingStatus == status).length;
  }
}
