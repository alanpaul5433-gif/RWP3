import 'package:equatable/equatable.dart';

class LocationLatLng extends Equatable {
  final double latitude;
  final double longitude;
  final String address;

  const LocationLatLng({
    required this.latitude,
    required this.longitude,
    this.address = '',
  });

  const LocationLatLng.empty()
      : latitude = 0.0,
        longitude = 0.0,
        address = '';

  @override
  List<Object?> get props => [latitude, longitude, address];

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
      };

  factory LocationLatLng.fromJson(Map<String, dynamic> json) {
    return LocationLatLng(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      address: json['address'] ?? '',
    );
  }
}
