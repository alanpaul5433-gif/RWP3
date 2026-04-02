import 'dart:async';
import 'dart:math';
import 'package:core/core.dart';

class MockRentalDataSource {
  final Map<String, RentalEntity> _rides = {};
  final Map<String, StreamController<RentalEntity>> _controllers = {};

  Future<List<RentalPackage>> getRentalPackages() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [
      RentalPackage(id: 'rp_1', name: '2 Hours / 20 KM', hours: 2, km: 20, price: 200),
      RentalPackage(id: 'rp_2', name: '4 Hours / 40 KM', hours: 4, km: 40, price: 350),
      RentalPackage(id: 'rp_3', name: '8 Hours / 80 KM', hours: 8, km: 80, price: 600),
      RentalPackage(id: 'rp_4', name: '12 Hours / 120 KM', hours: 12, km: 120, price: 850),
    ];
  }

  Future<RentalEntity> createRide({
    required String customerId,
    required LocationLatLng pickup,
    required String vehicleTypeId,
    required String vehicleTypeName,
    required RentalPackage package,
    required String paymentType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final now = DateTime.now();
    final id = 'rn_${now.millisecondsSinceEpoch}';

    final ride = RentalEntity(
      id: id,
      customerId: customerId,
      bookingStatus: BookingStatus.placed,
      pickupLocation: pickup,
      vehicleTypeId: vehicleTypeId,
      vehicleTypeName: vehicleTypeName,
      rentalPackage: package,
      otp: '${Random().nextInt(9000) + 1000}',
      totalAmount: package.price,
      paymentType: paymentType,
      createdAt: now,
      updatedAt: now,
    );
    _rides[id] = ride;
    _simulateAssignment(id);
    return ride;
  }

  Stream<RentalEntity> watchRide(String rideId) {
    _controllers[rideId]?.close();
    final controller = StreamController<RentalEntity>.broadcast();
    _controllers[rideId] = controller;
    final current = _rides[rideId];
    if (current != null) controller.add(current);
    return controller.stream;
  }

  Future<RentalEntity> cancelRide(String rideId, String reason) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final existing = _rides[rideId];
    if (existing == null) throw const ServerException('Ride not found');

    final cancelled = RentalEntity(
      id: existing.id,
      customerId: existing.customerId,
      bookingStatus: BookingStatus.cancelled,
      pickupLocation: existing.pickupLocation,
      vehicleTypeId: existing.vehicleTypeId,
      rentalPackage: existing.rentalPackage,
      cancellationReason: reason,
      cancelledBy: 'customer',
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
    _rides[rideId] = cancelled;
    _controllers[rideId]?.add(cancelled);
    return cancelled;
  }

  Future<List<RentalEntity>> getRidesByStatus(String customerId, String status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _rides.values.where((r) => r.customerId == customerId && r.bookingStatus == status).toList();
  }

  void _simulateAssignment(String rideId) {
    Future.delayed(const Duration(seconds: 3), () {
      final existing = _rides[rideId];
      if (existing == null || existing.bookingStatus != BookingStatus.placed) {
        return;
      }
      final assigned = RentalEntity(
        id: existing.id,
        customerId: existing.customerId,
        driverId: 'driver_rn_1',
        bookingStatus: BookingStatus.driverAssigned,
        pickupLocation: existing.pickupLocation,
        vehicleTypeId: existing.vehicleTypeId,
        vehicleTypeName: existing.vehicleTypeName,
        rentalPackage: existing.rentalPackage,
        otp: existing.otp,
        totalAmount: existing.totalAmount,
        paymentType: existing.paymentType,
        driverName: 'Rental Driver',
        driverPhone: '+1555000333',
        driverVehicleNumber: 'RN 3456',
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
      );
      _rides[rideId] = assigned;
      _controllers[rideId]?.add(assigned);
    });
  }

  void dispose() {
    for (final c in _controllers.values) { c.close(); }
    _controllers.clear();
  }
}
