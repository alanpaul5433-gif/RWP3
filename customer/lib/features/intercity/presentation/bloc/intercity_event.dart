part of 'intercity_bloc.dart';

sealed class IntercityEvent extends Equatable {
  const IntercityEvent();
  @override
  List<Object?> get props => [];
}

class IntercityCreateRequested extends IntercityEvent {
  final String customerId;
  final LocationLatLng source;
  final LocationLatLng destination;
  final List<LocationLatLng> stops;
  final String vehicleTypeId;
  final String vehicleTypeName;
  final String rideType;
  final List<SharingPerson> sharingPersons;
  final double totalAmount;
  final String paymentType;

  const IntercityCreateRequested({
    required this.customerId,
    required this.source,
    required this.destination,
    this.stops = const [],
    required this.vehicleTypeId,
    this.vehicleTypeName = '',
    this.rideType = 'personal',
    this.sharingPersons = const [],
    required this.totalAmount,
    required this.paymentType,
  });

  @override
  List<Object?> get props => [customerId, source, destination, vehicleTypeId];
}

class IntercityWatchRequested extends IntercityEvent {
  final String rideId;
  const IntercityWatchRequested(this.rideId);
  @override
  List<Object?> get props => [rideId];
}

class IntercityCancelRequested extends IntercityEvent {
  final String rideId;
  final String reason;
  const IntercityCancelRequested({required this.rideId, required this.reason});
  @override
  List<Object?> get props => [rideId, reason];
}

class IntercityHistoryRequested extends IntercityEvent {
  final String customerId;
  final String status;
  const IntercityHistoryRequested({required this.customerId, required this.status});
  @override
  List<Object?> get props => [customerId, status];
}
