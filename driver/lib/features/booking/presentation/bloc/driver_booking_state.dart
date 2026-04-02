part of 'driver_booking_bloc.dart';

sealed class DriverBookingState extends Equatable {
  const DriverBookingState();
  @override
  List<Object?> get props => [];
}

class DriverBookingInitial extends DriverBookingState { const DriverBookingInitial(); }
class DriverBookingProcessing extends DriverBookingState { const DriverBookingProcessing(); }

class DriverBookingAcceptedState extends DriverBookingState {
  final BookingEntity booking;
  const DriverBookingAcceptedState(this.booking);
  @override
  List<Object?> get props => [booking];
}

class DriverBookingRejectedState extends DriverBookingState {
  final BookingEntity booking;
  const DriverBookingRejectedState(this.booking);
  @override
  List<Object?> get props => [booking];
}

class DriverOtpVerifiedState extends DriverBookingState {
  final String bookingId;
  const DriverOtpVerifiedState(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}

class DriverRideOngoing extends DriverBookingState {
  final BookingEntity booking;
  const DriverRideOngoing(this.booking);
  @override
  List<Object?> get props => [booking];
}

class DriverRideCompletedState extends DriverBookingState {
  final BookingEntity booking;
  const DriverRideCompletedState(this.booking);
  @override
  List<Object?> get props => [booking];
}

class DriverBookingError extends DriverBookingState {
  final String message;
  const DriverBookingError(this.message);
  @override
  List<Object?> get props => [message];
}
