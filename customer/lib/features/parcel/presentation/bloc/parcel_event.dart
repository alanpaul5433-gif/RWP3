part of 'parcel_bloc.dart';

sealed class ParcelEvent extends Equatable {
  const ParcelEvent();
  @override
  List<Object?> get props => [];
}

class ParcelCreateRequested extends ParcelEvent {
  final String customerId;
  final LocationLatLng pickup;
  final LocationLatLng drop;
  final String vehicleTypeId;
  final String vehicleTypeName;
  final String parcelWeight;
  final String parcelDimension;
  final double totalAmount;
  final String paymentType;

  const ParcelCreateRequested({
    required this.customerId, required this.pickup, required this.drop,
    required this.vehicleTypeId, this.vehicleTypeName = '',
    required this.parcelWeight, required this.parcelDimension,
    required this.totalAmount, required this.paymentType,
  });

  @override
  List<Object?> get props => [customerId, pickup, drop, vehicleTypeId];
}

class ParcelWatchRequested extends ParcelEvent {
  final String rideId;
  const ParcelWatchRequested(this.rideId);
  @override
  List<Object?> get props => [rideId];
}

class ParcelCancelRequested extends ParcelEvent {
  final String rideId;
  final String reason;
  const ParcelCancelRequested({required this.rideId, required this.reason});
  @override
  List<Object?> get props => [rideId, reason];
}

class ParcelHistoryRequested extends ParcelEvent {
  final String customerId;
  final String status;
  const ParcelHistoryRequested({required this.customerId, required this.status});
  @override
  List<Object?> get props => [customerId, status];
}
