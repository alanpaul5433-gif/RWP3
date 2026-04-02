part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final DashboardStatsEntity stats;
  final List<UserEntity> recentCustomers;
  final List<BookingEntity> recentBookings;

  const DashboardLoaded({
    required this.stats,
    required this.recentCustomers,
    required this.recentBookings,
  });

  @override
  List<Object?> get props => [stats, recentCustomers, recentBookings];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}
