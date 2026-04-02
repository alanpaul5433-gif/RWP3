import 'dart:async';
import 'dart:math';
import 'package:core/core.dart';

class MockIntercityDataSource {
  final Map<String, IntercityEntity> _rides = {};
  final Map<String, StreamController<IntercityEntity>> _controllers = {};

  Future<IntercityEntity> createRide({
    required String customerId,
    required LocationLatLng source,
    required LocationLatLng destination,
    required List<LocationLatLng> stops,
    required String vehicleTypeId,
    required String vehicleTypeName,
    required String rideType,
    required List<SharingPerson> sharingPersons,
    required double totalAmount,
    required String paymentType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final now = DateTime.now();
    final id = 'ic_${now.millisecondsSinceEpoch}';

    final ride = IntercityEntity(
      id: id,
      customerId: customerId,
      bookingStatus: BookingStatus.placed,
      sourceLocation: source,
      destinationLocation: destination,
      stops: stops,
      vehicleTypeId: vehicleTypeId,
      vehicleTypeName: vehicleTypeName,
      rideType: rideType,
      sharingPersons: sharingPersons,
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

  Stream<IntercityEntity> watchRide(String rideId) {
    _controllers[rideId]?.close();
    final controller = StreamController<IntercityEntity>.broadcast();
    _controllers[rideId] = controller;
    final current = _rides[rideId];
    if (current != null) controller.add(current);
    return controller.stream;
  }

  Future<IntercityEntity> cancelRide(String rideId, String reason) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final existing = _rides[rideId];
    if (existing == null) throw const ServerException('Ride not found');

    final cancelled = IntercityEntity(
      id: existing.id,
      customerId: existing.customerId,
      bookingStatus: BookingStatus.cancelled,
      sourceLocation: existing.sourceLocation,
      destinationLocation: existing.destinationLocation,
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

  Future<List<IntercityEntity>> getRidesByStatus(String customerId, String status) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _rides.values
        .where((r) => r.customerId == customerId && r.bookingStatus == status)
        .toList();
  }

  void _simulateAssignment(String rideId) {
    Future.delayed(const Duration(seconds: 3), () {
      final existing = _rides[rideId];
      if (existing == null || existing.bookingStatus != BookingStatus.placed) {
        return;
      }
      final assigned = IntercityEntity(
        id: existing.id,
        customerId: existing.customerId,
        driverId: 'driver_ic_1',
        bookingStatus: BookingStatus.driverAssigned,
        sourceLocation: existing.sourceLocation,
        destinationLocation: existing.destinationLocation,
        stops: existing.stops,
        vehicleTypeId: existing.vehicleTypeId,
        vehicleTypeName: existing.vehicleTypeName,
        rideType: existing.rideType,
        sharingPersons: existing.sharingPersons,
        otp: existing.otp,
        totalAmount: existing.totalAmount,
        paymentType: existing.paymentType,
        driverName: 'IC Driver',
        driverPhone: '+1555000111',
        driverVehicleNumber: 'IC 5678',
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
      );
      _rides[rideId] = assigned;
      _controllers[rideId]?.add(assigned);
    });
  }

  void dispose() {
    for (final c in _controllers.values) {
      c.close();
    }
    _controllers.clear();
  }
}
