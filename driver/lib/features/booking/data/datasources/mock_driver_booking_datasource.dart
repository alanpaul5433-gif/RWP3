import 'package:core/core.dart';

class MockDriverBookingDataSource {
  final Map<String, BookingEntity> _bookings = {};

  void seedBooking(BookingEntity booking) {
    _bookings[booking.id] = booking;
  }

  Future<BookingEntity> acceptBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final existing = _bookings[bookingId];
    if (existing == null) throw const ServerException('Booking not found');

    final accepted = BookingEntity(
      id: existing.id, customerId: existing.customerId, driverId: existing.driverId,
      bookingStatus: BookingStatus.accepted,
      pickupLocation: existing.pickupLocation, dropLocation: existing.dropLocation,
      vehicleTypeId: existing.vehicleTypeId, vehicleTypeName: existing.vehicleTypeName,
      otp: existing.otp, estimatedFare: existing.estimatedFare,
      paymentType: existing.paymentType,
      driverName: existing.driverName, driverPhone: existing.driverPhone,
      driverVehicleNumber: existing.driverVehicleNumber,
      createdAt: existing.createdAt, updatedAt: DateTime.now(),
    );
    _bookings[bookingId] = accepted;
    return accepted;
  }

  Future<BookingEntity> rejectBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final existing = _bookings[bookingId];
    if (existing == null) throw const ServerException('Booking not found');

    final rejected = BookingEntity(
      id: existing.id, customerId: existing.customerId,
      bookingStatus: BookingStatus.rejected,
      pickupLocation: existing.pickupLocation, dropLocation: existing.dropLocation,
      vehicleTypeId: existing.vehicleTypeId,
      createdAt: existing.createdAt, updatedAt: DateTime.now(),
    );
    _bookings[bookingId] = rejected;
    return rejected;
  }

  Future<bool> verifyOtp(String bookingId, String otp) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final existing = _bookings[bookingId];
    if (existing == null) throw const ServerException('Booking not found');
    return existing.otp == otp;
  }

  Future<BookingEntity> startRide(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final existing = _bookings[bookingId];
    if (existing == null) throw const ServerException('Booking not found');

    final started = BookingEntity(
      id: existing.id, customerId: existing.customerId, driverId: existing.driverId,
      bookingStatus: BookingStatus.ongoing,
      pickupLocation: existing.pickupLocation, dropLocation: existing.dropLocation,
      vehicleTypeId: existing.vehicleTypeId, vehicleTypeName: existing.vehicleTypeName,
      estimatedFare: existing.estimatedFare, paymentType: existing.paymentType,
      pickupTime: DateTime.now(),
      createdAt: existing.createdAt, updatedAt: DateTime.now(),
    );
    _bookings[bookingId] = started;
    return started;
  }

  Future<BookingEntity> completeRide(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final existing = _bookings[bookingId];
    if (existing == null) throw const ServerException('Booking not found');

    final completed = BookingEntity(
      id: existing.id, customerId: existing.customerId, driverId: existing.driverId,
      bookingStatus: BookingStatus.completed,
      pickupLocation: existing.pickupLocation, dropLocation: existing.dropLocation,
      vehicleTypeId: existing.vehicleTypeId, vehicleTypeName: existing.vehicleTypeName,
      estimatedFare: existing.estimatedFare, totalAmount: existing.estimatedFare,
      paymentType: existing.paymentType, paymentStatus: true,
      pickupTime: existing.pickupTime, dropTime: DateTime.now(),
      createdAt: existing.createdAt, updatedAt: DateTime.now(),
    );
    _bookings[bookingId] = completed;
    return completed;
  }
}
