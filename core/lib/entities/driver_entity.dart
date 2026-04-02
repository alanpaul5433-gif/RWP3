import 'package:equatable/equatable.dart';
import 'location_latlng.dart';

class DriverEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String profilePic;
  final String gender;
  final String dateOfBirth;
  final String loginType;
  final String fcmToken;
  final double walletAmount;
  final double totalEarning;
  final int reviewsCount;
  final double reviewsSum;
  final bool isActive;
  final bool isVerified;
  final bool isOnline;
  final String? currentBookingId;
  final LocationLatLng location;
  final String vehicleTypeName;
  final String vehicleBrandName;
  final String vehicleModelName;
  final String vehicleNumber;
  final List<DriverDocument> verifyDocument;
  final List<String> zoneIds;
  final String? subscriptionPlanId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DriverEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber = '',
    this.countryCode = '',
    this.profilePic = '',
    this.gender = '',
    this.dateOfBirth = '',
    this.loginType = '',
    this.fcmToken = '',
    this.walletAmount = 0,
    this.totalEarning = 0,
    this.reviewsCount = 0,
    this.reviewsSum = 0,
    this.isActive = true,
    this.isVerified = false,
    this.isOnline = false,
    this.currentBookingId,
    this.location = const LocationLatLng.empty(),
    this.vehicleTypeName = '',
    this.vehicleBrandName = '',
    this.vehicleModelName = '',
    this.vehicleNumber = '',
    this.verifyDocument = const [],
    this.zoneIds = const [],
    this.subscriptionPlanId,
    required this.createdAt,
    required this.updatedAt,
  });

  double get averageRating =>
      reviewsCount > 0 ? reviewsSum / reviewsCount : 0;

  @override
  List<Object?> get props => [id, email, isVerified, isOnline];
}

class DriverDocument extends Equatable {
  final String documentId;
  final String frontImage;
  final String backImage;
  final bool isVerified;

  const DriverDocument({
    required this.documentId,
    this.frontImage = '',
    this.backImage = '',
    this.isVerified = false,
  });

  @override
  List<Object?> get props => [documentId, isVerified];
}
