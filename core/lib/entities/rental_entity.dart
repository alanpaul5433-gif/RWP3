import 'package:equatable/equatable.dart';
import 'location_latlng.dart';

class RentalEntity extends Equatable {
  final String id;
  final String customerId;
  final String? driverId;
  final String bookingStatus;
  final LocationLatLng pickupLocation;
  final String vehicleTypeId;
  final String vehicleTypeName;
  final RentalPackage rentalPackage;
  final double currentKm;
  final double completedKm;
  final double extraHourCharge;
  final double extraKmCharge;
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

  const RentalEntity({
    required this.id,
    required this.customerId,
    this.driverId,
    required this.bookingStatus,
    required this.pickupLocation,
    required this.vehicleTypeId,
    this.vehicleTypeName = '',
    required this.rentalPackage,
    this.currentKm = 0,
    this.completedKm = 0,
    this.extraHourCharge = 0,
    this.extraKmCharge = 0,
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

class RentalPackage extends Equatable {
  final String id;
  final String name;
  final int hours;
  final int km;
  final double price;

  const RentalPackage({
    required this.id,
    required this.name,
    required this.hours,
    required this.km,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, hours, km, price];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'hours': hours,
        'km': km,
        'price': price,
      };

  factory RentalPackage.fromJson(Map<String, dynamic> json) {
    return RentalPackage(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      hours: json['hours'] ?? 0,
      km: json['km'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}
