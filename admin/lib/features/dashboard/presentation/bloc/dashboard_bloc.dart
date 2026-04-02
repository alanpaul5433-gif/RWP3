import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_dashboard_datasource.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final MockDashboardDataSource _dataSource;

  DashboardBloc({required MockDashboardDataSource dataSource})
      : _dataSource = dataSource,
        super(const DashboardInitial()) {
    on<DashboardLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    try {
      final results = await Future.wait([
        _dataSource.getStats(),
        _dataSource.getRecentCustomers(),
        _dataSource.getRecentBookings(),
      ]);
      emit(DashboardLoaded(
        stats: results[0] as DashboardStatsEntity,
        recentCustomers: results[1] as List<UserEntity>,
        recentBookings: results[2] as List<BookingEntity>,
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
