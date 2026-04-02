import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_driver_home_datasource.dart';

part 'driver_home_event.dart';
part 'driver_home_state.dart';

class DriverHomeBloc extends Bloc<DriverHomeEvent, DriverHomeState> {
  final MockDriverHomeDataSource _dataSource;

  DriverHomeBloc({required MockDriverHomeDataSource dataSource})
      : _dataSource = dataSource,
        super(const DriverHomeInitial()) {
    on<DriverHomeDashboardRequested>(_onDashboard);
    on<DriverStatusToggled>(_onToggle);
    on<DriverIncomingBookingsRequested>(_onIncoming);
  }

  Future<void> _onDashboard(DriverHomeDashboardRequested event, Emitter<DriverHomeState> emit) async {
    emit(const DriverHomeLoading());
    try {
      final stats = await _dataSource.getStats(event.driverId);
      emit(DriverHomeDashboardLoaded(stats: stats, isOnline: false));
    } catch (e) {
      emit(DriverHomeError(e.toString()));
    }
  }

  Future<void> _onToggle(DriverStatusToggled event, Emitter<DriverHomeState> emit) async {
    try {
      final isOnline = await _dataSource.toggleOnline(event.driverId, event.online);
      final currentState = state;
      if (currentState is DriverHomeDashboardLoaded) {
        emit(DriverHomeDashboardLoaded(stats: currentState.stats, isOnline: isOnline));
      } else {
        emit(DriverHomeDashboardLoaded(stats: const {}, isOnline: isOnline));
      }
    } catch (e) {
      emit(DriverHomeError(e.toString()));
    }
  }

  Future<void> _onIncoming(DriverIncomingBookingsRequested event, Emitter<DriverHomeState> emit) async {
    try {
      final bookings = await _dataSource.getIncomingBookings(event.driverId);
      emit(DriverIncomingBookingsLoaded(bookings));
    } catch (e) {
      emit(DriverHomeError(e.toString()));
    }
  }
}
