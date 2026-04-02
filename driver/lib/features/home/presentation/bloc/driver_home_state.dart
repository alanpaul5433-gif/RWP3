part of 'driver_home_bloc.dart';

sealed class DriverHomeState extends Equatable {
  const DriverHomeState();
  @override
  List<Object?> get props => [];
}

class DriverHomeInitial extends DriverHomeState { const DriverHomeInitial(); }
class DriverHomeLoading extends DriverHomeState { const DriverHomeLoading(); }

class DriverHomeDashboardLoaded extends DriverHomeState {
  final Map<String, int> stats;
  final bool isOnline;
  const DriverHomeDashboardLoaded({required this.stats, required this.isOnline});
  @override
  List<Object?> get props => [stats, isOnline];
}

class DriverIncomingBookingsLoaded extends DriverHomeState {
  final List<BookingEntity> bookings;
  const DriverIncomingBookingsLoaded(this.bookings);
  @override
  List<Object?> get props => [bookings];
}

class DriverHomeError extends DriverHomeState {
  final String message;
  const DriverHomeError(this.message);
  @override
  List<Object?> get props => [message];
}
