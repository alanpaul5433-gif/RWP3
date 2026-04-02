import 'package:equatable/equatable.dart';
import 'location_latlng.dart';

class IntercityEntity extends Equatable {
  final String id;
  final String customerId;
  final String? driverId;
  final String bookingStatus;
  final LocationLatLng sourceLocation;
  final LocationLatLng destinationLocation;
  final List<LocationLatLng> stops;
  final String vehicleTypeId;
  final String vehicleTypeName;
  final String rideType; // personal | sharing
  final List<SharingPerson> sharingPersons;
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

  const IntercityEntity({
    required this.id,
    required this.customerId,
    this.driverId,
    required this.bookingStatus,
    required this.sourceLocation,
    required this.destinationLocation,
    this.stops = const [],
    required this.vehicleTypeId,
    this.vehicleTypeName = '',
    this.rideType = 'personal',
    this.sharingPersons = const [],
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

class SharingPerson extends Equatable {
  final String name;
  final String phone;

  const SharingPerson({required this.name, required this.phone});

  @override
  List<Object?> get props => [name, phone];

  Map<String, dynamic> toJson() => {'name': name, 'phone': phone};

  factory SharingPerson.fromJson(Map<String, dynamic> json) {
    return SharingPerson(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
