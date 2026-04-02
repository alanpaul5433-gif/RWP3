import 'dart:async';
import 'dart:math';
import 'package:core/core.dart';

class MockParcelDataSource {
  final Map<String, ParcelEntity> _rides = {};
  final Map<String, StreamController<ParcelEntity>> _controllers = {};

  Future<ParcelEntity> createRide({
    required String customerId,
    required LocationLatLng pickup,
    required LocationLatLng drop,
    required String vehicleTypeId,
    required String vehicleTypeName,
    String? parcelImage,
    required String parcelWeight,
    required String parcelDimension,
    required double totalAmount,
    required String paymentType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final now = DateTime.now();
    final id = 'pc_${now.millisecondsSinceEpoch}';

    final ride = ParcelEntity(
      id: id,
      customerId: customerId,
      bookingStatus: BookingStatus.placed,
      pickupLocation: pickup,
      dropLocation: drop,
      vehicleTypeId: vehicleTypeId,
      vehicleTypeName: vehicleTypeName,
      parcelImage: parcelImage,
      parcelWeight: parcelWeight,
      parcelDimension: parcelDimension,
      otp: '${Random().nextInt(9000) + 1000}',
      totalAmount: totalAmount,
      paymentType: paymentType,
      createdAt: now,
      updatedAt: now,
    );
    _rides[id] = ride;
    _simulateAssignment(id);
    return ride;
  }

  Stream<ParcelEntity> watchRide(String rideId) {
    _controllers[rideId]?.close();
    final controller = StreamController<ParcelEntity>.broadcast();
    _controllers[rideId] = controller;
    final current = _rides[rideId];
    if (current != null) controller.add(current);
    return controller.stream;
  }

  Future<ParcelEntity> cancelRide(String rideId, String reason) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final existing = _rides[rideId];
    if (existing == null) throw const ServerException('Ride not found');

    final cancelled = ParcelEntity(
      id: existing.id,
      customerId: existing.customerId,
      bookingStatus: BookingStatus.cancelled,
      pickupLocation: existing.pickupLocation,
      dropLocation: existing.dropLocation,
      vehicleTypeId: existing.vehicleTypeId,
      cancellationReason: reason,
      cancelledBy: 'customer',
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
    _rides[rideId] = cancelled;
    _controllers[rideId]?.add(cancelled);
    return cancelled;
  }

  Future<List<ParcelEntity>> getRidesByStatus(String customerId, String status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _rides.values.where((r) => r.customerId == customerId && r.bookingStatus == status).toList();
  }

  void _simulateAssignment(String rideId) {
    Future.delayed(const Duration(seconds: 3), () {
      final existing = _rides[rideId];
      if (existing == null || existing.bookingStatus != BookingStatus.placed) {
        return;
      }
      final assigned = ParcelEntity(
        id: existing.id,
        customerId: existing.customerId,
        driverId: 'driver_pc_1',
        bookingStatus: BookingStatus.driverAssigned,
        pickupLocation: existing.pickupLocation,
        dropLocation: existing.dropLocation,
        vehicleTypeId: existing.vehicleTypeId,
        vehicleTypeName: existing.vehicleTypeName,
        parcelWeight: existing.parcelWeight,
        parcelDimension: existing.parcelDimension,
        otp: existing.otp,
        totalAmount: existing.totalAmount,
        paymentType: existing.paymentType,
        driverName: 'Parcel Driver',
        driverPhone: '+1555000222',
        driverVehicleNumber: 'PC 9012',
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
