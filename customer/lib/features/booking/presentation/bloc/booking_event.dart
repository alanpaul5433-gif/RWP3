part of 'booking_bloc.dart';

sealed class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

class BookingCreateRequested extends BookingEvent {
  final String customerId;
  final LocationLatLng pickup;
  final LocationLatLng drop;
  final List<LocationLatLng> stops;
  final String vehicleTypeId;
  final String vehicleTypeName;
  final double estimatedFare;
  final String paymentType;
  final bool isOnlyForFemale;

  const BookingCreateRequested({
    required this.customerId,
    required this.pickup,
    required this.drop,
    this.stops = const [],
    required this.vehicleTypeId,
    this.vehicleTypeName = '',
    required this.estimatedFare,
    required this.paymentType,
    this.isOnlyForFemale = false,
  });

  @override
  List<Object?> get props =>
      [customerId, pickup, drop, vehicleTypeId, paymentType];
}

class BookingWatchRequested extends BookingEvent {
  final String bookingId;
  const BookingWatchRequested(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

class BookingCancelRequested extends BookingEvent {
  final String bookingId;
  final String reason;

  const BookingCancelRequested({
    required this.bookingId,
    required this.reason,
  });

  @override
  List<Object?> get props => [bookingId, reason];
}

class BookingHistoryRequested extends BookingEvent {
  final String customerId;
  final String status;

  const BookingHistoryRequested({
    required this.customerId,
    required this.status,
  });

  @override
  List<Object?> get props => [customerId, status];
}
