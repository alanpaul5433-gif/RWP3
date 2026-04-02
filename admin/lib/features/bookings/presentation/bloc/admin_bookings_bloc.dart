import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_admin_bookings_datasource.dart';

part 'admin_bookings_event.dart';
part 'admin_bookings_state.dart';

class AdminBookingsBloc extends Bloc<AdminBookingsEvent, AdminBookingsState> {
  final MockAdminBookingsDataSource _dataSource;

  AdminBookingsBloc({required MockAdminBookingsDataSource dataSource})
      : _dataSource = dataSource,
        super(const AdminBookingsInitial()) {
    on<AdminBookingsLoadRequested>(_onLoad);
    on<AdminBookingsFilterChanged>(_onFilter);
  }

  Future<void> _onLoad(AdminBookingsLoadRequested event, Emitter<AdminBookingsState> emit) async {
    emit(const AdminBookingsLoading());
    try {
      final bookings = await _dataSource.getBookings(page: event.page, pageSize: event.pageSize);
      final total = await _dataSource.getCount();
      emit(AdminBookingsLoaded(bookings: bookings, totalCount: total, currentPage: event.page));
    } catch (e) {
      emit(AdminBookingsError(e.toString()));
    }
  }

  Future<void> _onFilter(AdminBookingsFilterChanged event, Emitter<AdminBookingsState> emit) async {
    emit(const AdminBookingsLoading());
    try {
      final bookings = await _dataSource.getBookings(status: event.status);
      final total = await _dataSource.getCount(status: event.status);
      emit(AdminBookingsLoaded(bookings: bookings, totalCount: total, currentPage: 0, filterStatus: event.status));
    } catch (e) {
      emit(AdminBookingsError(e.toString()));
    }
  }
}
