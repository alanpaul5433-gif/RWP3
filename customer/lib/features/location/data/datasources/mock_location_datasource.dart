import 'dart:math';
import 'package:core/core.dart';

class MockLocationDataSource {
  Future<LocationLatLng> getCurrentLocation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock: San Francisco downtown
    return const LocationLatLng(
      latitude: 37.7749,
      longitude: -122.4194,
      address: '123 Market St, San Francisco, CA',
    );
  }

  Future<DistanceEntity> calculateRoute(
    LocationLatLng origin,
    LocationLatLng destination,
    List<LocationLatLng> stops,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Calculate straight-line distance and estimate road distance as 1.3x
    final straightLine = _haversine(
      origin.latitude,
      origin.longitude,
      destination.latitude,
      destination.longitude,
    );
    final roadDistance = straightLine * 1.3;
    // Estimate time: average 30 km/h in city
    final duration = (roadDistance / 30) * 60;

    return DistanceEntity(
      distanceInMeters: roadDistance * 1000,
      distanceInKm: roadDistance,
      durationInMinutes: duration,
    );
  }

  Future<FareEntity> estimateFare({
    required DistanceEntity distance,
    required VehicleTypeEntity vehicleType,
    double taxPercent = 8,
    double commissionPercent = 20,
    bool isNight = false,
    double nightChargePercent = 15,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final distanceCharge = distance.distanceInKm * vehicleType.perKmRate;
    final timeCharge = distance.durationInMinutes * vehicleType.perMinuteRate;
    final rawTotal = vehicleType.baseFare + distanceCharge + timeCharge;
    final subTotal =
        rawTotal > vehicleType.minimumFare ? rawTotal : vehicleType.minimumFare;

    final nightCharge = isNight ? subTotal * nightChargePercent / 100 : 0.0;
    const holdCharge = 0.0;
    final grossTotal = subTotal + nightCharge + holdCharge;

    const discount = 0.0; // No coupon applied in estimate
    final afterDiscount = grossTotal - discount;
    final taxAmount = afterDiscount * taxPercent / 100;
    final totalAmount = afterDiscount + taxAmount;
    final adminCommission = totalAmount * commissionPercent / 100;
    final driverEarning = totalAmount - adminCommission;

    return FareEntity(
      baseFare: vehicleType.baseFare,
      distanceCharge: distanceCharge,
      timeCharge: timeCharge,
      subTotal: subTotal,
      nightCharge: nightCharge,
      holdCharge: holdCharge,
      grossTotal: grossTotal,
      discount: discount,
      taxAmount: _round(taxAmount),
      totalAmount: _round(totalAmount),
      adminCommission: _round(adminCommission),
      driverEarning: _round(driverEarning),
    );
  }

  double _round(double value) => (value * 100).roundToDouble() / 100;

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  double _toRad(double deg) => deg * pi / 180;
}
