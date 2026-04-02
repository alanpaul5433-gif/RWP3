import 'package:equatable/equatable.dart';
import 'location_latlng.dart';

class SosAlertEntity extends Equatable {
  final String id;
  final String userId;
  final String? bookingId;
  final LocationLatLng location;
  final String contactNumber;
  final String type; // emergency
  final DateTime createdAt;

  const SosAlertEntity({
    required this.id,
    required this.userId,
    this.bookingId,
    required this.location,
    this.contactNumber = '',
    this.type = 'emergency',
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, bookingId];
}
