part of 'driver_booking_bloc.dart';

sealed class DriverBookingEvent extends Equatable {
  const DriverBookingEvent();
  @override
  List<Object?> get props => [];
}

class DriverBookingAccepted extends DriverBookingEvent {
  final String bookingId;
  const DriverBookingAccepted(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}

class DriverBookingRejected extends DriverBookingEvent {
  final String bookingId;
  const DriverBookingRejected(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}

class DriverOtpVerified extends DriverBookingEvent {
  final String bookingId;
  final String otp;
  const DriverOtpVerified({required this.bookingId, required this.otp});
  @override
  List<Object?> get props => [bookingId, otp];
}

class DriverRideStarted extends DriverBookingEvent {
  final String bookingId;
  const DriverRideStarted(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}

class DriverRideCompleted extends DriverBookingEvent {
  final String bookingId;
  const DriverRideCompleted(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}
