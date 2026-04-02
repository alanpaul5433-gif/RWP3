import 'package:equatable/equatable.dart';
import 'location_latlng.dart';

class ParcelEntity extends Equatable {
  final String id;
  final String customerId;
  final String? driverId;
  final String bookingStatus;
  final LocationLatLng pickupLocation;
  final LocationLatLng dropLocation;
  final String? parcelImage;
  final String parcelWeight;
  final String parcelDimension;
  final String vehicleTypeId;
  final String vehicleTypeName;
  final String? otp;
  final double subTotal;
  final double totalAmount;
  final String paymentType;
  final bool paymentStatus;
  final String? driverName;
  final String? driverPhone;
  final String? driverVehicleNumber;
  final String? cancellationReason;
  final String? cancelledBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ParcelEntity({
    required this.id,
    required this.customerId,
    this.driverId,
    required this.bookingStatus,
    required this.pickupLocation,
    required this.dropLocation,
    this.parcelImage,
    this.parcelWeight = '',
    this.parcelDimension = '',
    required this.vehicleTypeId,
    this.vehicleTypeName = '',
    this.otp,
    this.subTotal = 0,
    this.totalAmount = 0,
    this.paymentType = 'cash',
    this.paymentStatus = false,
    this.driverName,
    this.driverPhone,
    this.driverVehicleNumber,
    this.cancellationReason,
    this.cancelledBy,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, bookingStatus, customerId];
}
