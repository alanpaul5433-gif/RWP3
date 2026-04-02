part of 'driver_home_bloc.dart';

sealed class DriverHomeEvent extends Equatable {
  const DriverHomeEvent();
  @override
  List<Object?> get props => [];
}

class DriverHomeDashboardRequested extends DriverHomeEvent {
  final String driverId;
  const DriverHomeDashboardRequested(this.driverId);
  @override
  List<Object?> get props => [driverId];
}

class DriverStatusToggled extends DriverHomeEvent {
  final String driverId;
  final bool online;
  const DriverStatusToggled({required this.driverId, required this.online});
  @override
  List<Object?> get props => [driverId, online];
}

class DriverIncomingBookingsRequested extends DriverHomeEvent {
  final String driverId;
  const DriverIncomingBookingsRequested(this.driverId);
  @override
  List<Object?> get props => [driverId];
}
