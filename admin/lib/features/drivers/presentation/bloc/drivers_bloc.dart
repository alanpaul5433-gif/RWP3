import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_driver_datasource.dart';

part 'drivers_event.dart';
part 'drivers_state.dart';

class DriversBloc extends Bloc<DriversEvent, DriversState> {
  final MockDriverDataSource _dataSource;

  DriversBloc({required MockDriverDataSource dataSource})
      : _dataSource = dataSource,
        super(const DriversInitial()) {
    on<DriversLoadRequested>(_onLoad);
    on<UnverifiedDriversRequested>(_onUnverified);
    on<OnlineDriversRequested>(_onOnline);
    on<DriverDetailRequested>(_onDetail);
    on<DriverVerifyRequested>(_onVerify);
  }

  Future<void> _onLoad(
    DriversLoadRequested event,
    Emitter<DriversState> emit,
  ) async {
    emit(const DriversLoading());
    try {
      final drivers = await _dataSource.getDrivers(
        page: event.page,
        pageSize: event.pageSize,
        searchQuery: event.searchQuery,
      );
      emit(DriversLoaded(drivers: drivers));
    } catch (e) {
      emit(DriversError(e.toString()));
    }
  }

  Future<void> _onUnverified(
    UnverifiedDriversRequested event,
    Emitter<DriversState> emit,
  ) async {
    emit(const DriversLoading());
    try {
      final drivers = await _dataSource.getDrivers(isVerified: false);
      emit(DriversLoaded(drivers: drivers, filter: 'unverified'));
    } catch (e) {
      emit(DriversError(e.toString()));
    }
  }

  Future<void> _onOnline(
    OnlineDriversRequested event,
    Emitter<DriversState> emit,
  ) async {
    emit(const DriversLoading());
    try {
      final drivers = await _dataSource.getDrivers(isOnline: true);
      emit(DriversLoaded(drivers: drivers, filter: 'online'));
    } catch (e) {
      emit(DriversError(e.toString()));
    }
  }

  Future<void> _onDetail(
    DriverDetailRequested event,
    Emitter<DriversState> emit,
  ) async {
    try {
      final driver = await _dataSource.getDriver(event.driverId);
      emit(DriverDetailLoaded(driver));
    } catch (e) {
      emit(DriversError(e.toString()));
    }
  }

  Future<void> _onVerify(
    DriverVerifyRequested event,
    Emitter<DriversState> emit,
  ) async {
    try {
      final driver = await _dataSource.verifyDriver(event.driverId);
      emit(DriverVerified(driver));
    } catch (e) {
      emit(DriversError(e.toString()));
    }
  }
}
