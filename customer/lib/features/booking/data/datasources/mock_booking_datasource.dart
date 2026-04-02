import 'dart:async';
import 'dart:math';
import 'package:core/core.dart';

class MockBookingDataSource {
  final Map<String, BookingEntity> _bookings = {};
  final Map<String, StreamController<BookingEntity>> _controllers = {};

  Future<BookingEntity> createBooking({
    required String customerId,
    required LocationLatLng pickup,
    required LocationLatLng drop,
    required List<LocationLatLng> stops,
    required String vehicleTypeId,
    required String vehicleTypeName,
    required double estimatedFare,
    required String paymentType,
    bool isOnlyForFemale = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final now = DateTime.now();
    final id = 'bk_${now.millisecondsSinceEpoch}';
    final otp = '${Random().nextInt(9000) + 1000}';

    final booking = BookingEntity(
      id: id,
      customerId: customerId,
      bookingStatus: BookingStatus.placed,
      pickupLocation: pickup,
      dropLocation: drop,
      stops: stops,
      vehicleTypeId: vehicleTypeId,
      vehicleTypeName: vehicleTypeName,
      otp: otp,
      estimatedFare: estimatedFare,
      paymentType: paymentType,
      isOnlyForFemale: isOnlyForFemale,
      createdAt: now,
      updatedAt: now,
    );

    _bookings[id] = booking;

    // Simulate driver assignment after 3 seconds
    _simulateDriverAssignment(id);

    return booking;
  }

  Future<BookingEntity> getBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final booking = _bookings[bookingId];
    if (booking == null) throw const ServerException('Booking not found');
    return booking;
  }

  Stream<BookingEntity> watchBooking(String bookingId) {
    _controllers[bookingId]?.close();
    final controller = StreamController<BookingEntity>.broadcast();
    _controllers[bookingId] = controller;

    // Emit current state
    final current = _bookings[bookingId];
    if (current != null) {
      controller.add(current);
    }

    return controller.stream;
  }

  Future<List<BookingEntity>> getBookingsByStatus(
      String customerId, String status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _bookings.values
        .where((b) => b.customerId == customerId && b.bookingStatus == status)
        .toList();
  }

  Future<BookingEntity> cancelBooking(String bookingId, String reason) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final existing = _bookings[bookingId];
    if (existing == null) throw const ServerException('Booking not found');

    if (!BookingStatus.isValidTransition(
        existing.bookingStatus, BookingStatus.cancelled)) {
      throw const ServerException('Cannot cancel this booking');
    }

    final cancelled = BookingEntity(
      id: existing.id,
      customerId: existing.customerId,
      driverId: existing.driverId,
      bookingStatus: BookingStatus.cancelled,
      pickupLocation: existing.pickupLocation,
      dropLocation: existing.dropLocation,
      stops: existing.stops,
      vehicleTypeId: existing.vehicleTypeId,
      vehicleTypeName: existing.vehicleTypeName,
      estimatedFare: existing.estimatedFare,
      paymentType: existing.paymentType,
      cancellationReason: reason,
      cancelledBy: 'customer',
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
    _bookings[bookingId] = cancelled;
    _controllers[bookingId]?.add(cancelled);
    return cancelled;
  }

  void _simulateDriverAssignment(String bookingId) {
    Future.delayed(const Duration(seconds: 3), () {
      final existing = _bookings[bookingId];
      if (existing == null ||
          existing.bookingStatus != BookingStatus.placed) {
        return;
      }

      final assigned = BookingEntity(
        id: existing.id,
        customerId: existing.customerId,
        driverId: 'driver_mock_1',
        bookingStatus: BookingStatus.driverAssigned,
        pickupLocation: existing.pickupLocation,
        dropLocation: existing.dropLocation,
        stops: existing.stops,
        vehicleTypeId: existing.vehicleTypeId,
        vehicleTypeName: existing.vehicleTypeName,
        otp: existing.otp,
        estimatedFare: existing.estimatedFare,
        paymentType: existing.paymentType,
        driverName: 'Mock Driver',
        driverPhone: '+1987654321',
        driverVehicleNumber: 'ABC 1234',
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
      );
      _bookings[bookingId] = assigned;
      _controllers[bookingId]?.add(assigned);
    });
  }

  void dispose() {
    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }
}
