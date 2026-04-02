import 'package:equatable/equatable.dart';
import 'location_latlng.dart';

class BookingEntity extends Equatable {
  final String id;
  final String customerId;
  final String? driverId;
  final String bookingStatus;
  final LocationLatLng pickupLocation;
  final LocationLatLng dropLocation;
  final List<LocationLatLng> stops;
  final String vehicleTypeId;
  final String vehicleTypeName;
  final String? otp;
  final double estimatedFare;
  final double subTotal;
  final double discount;
  final double taxAmount;
  final double totalAmount;
  final double adminCommission;
  final String paymentType;
  final bool paymentStatus;
  final String? couponId;
  final double couponAmount;
  final String? cancellationReason;
  final String? cancelledBy;
  final double cancellationCharge;
  final double nightCharge;
  final double holdTimingCharge;
  final bool isOnlyForFemale;
  final double distanceKm;
  final double durationMinutes;
  final String? driverName;
  final String? driverPhone;
  final String? driverProfilePic;
  final String? driverVehicleNumber;
  final DateTime? pickupTime;
  final DateTime? dropTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BookingEntity({
    required this.id,
    required this.customerId,
    this.driverId,
    required this.bookingStatus,
    required this.pickupLocation,
    required this.dropLocation,
    this.stops = const [],
    required this.vehicleTypeId,
    this.vehicleTypeName = '',
    this.otp,
    this.estimatedFare = 0,
    this.subTotal = 0,
    this.discount = 0,
    this.taxAmount = 0,
    this.totalAmount = 0,
    this.adminCommission = 0,
    this.paymentType = 'cash',
    this.paymentStatus = false,
    this.couponId,
    this.couponAmount = 0,
    this.cancellationReason,
    this.cancelledBy,
    this.cancellationCharge = 0,
    this.nightCharge = 0,
    this.holdTimingCharge = 0,
    this.isOnlyForFemale = false,
    this.distanceKm = 0,
    this.durationMinutes = 0,
    this.driverName,
    this.driverPhone,
    this.driverProfilePic,
    this.driverVehicleNumber,
    this.pickupTime,
    this.dropTime,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, bookingStatus, customerId, driverId];
}
