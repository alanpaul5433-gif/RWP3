import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_vehicles_datasource.dart';

part 'vehicles_event.dart';
part 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  final MockVehiclesDataSource _dataSource;

  VehiclesBloc({required MockVehiclesDataSource dataSource})
      : _dataSource = dataSource, super(const VehiclesInitial()) {
    on<VehiclesLoadRequested>(_onLoad);
    on<VehicleTypeCreateRequested>(_onCreate);
    on<VehicleTypeUpdateRequested>(_onUpdate);
    on<VehicleTypeDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(VehiclesLoadRequested event, Emitter<VehiclesState> emit) async {
    emit(const VehiclesLoading());
    try {
      final types = await _dataSource.getVehicleTypes();
      final brands = await _dataSource.getBrands();
      emit(VehiclesLoaded(types: types, brands: brands));
    } catch (e) { emit(VehiclesError(e.toString())); }
  }

  Future<void> _onCreate(VehicleTypeCreateRequested event, Emitter<VehiclesState> emit) async {
    try { await _dataSource.createVehicleType(event.type); add(const VehiclesLoadRequested()); }
    catch (e) { emit(VehiclesError(e.toString())); }
  }

  Future<void> _onUpdate(VehicleTypeUpdateRequested event, Emitter<VehiclesState> emit) async {
    try { await _dataSource.updateVehicleType(event.type); add(const VehiclesLoadRequested()); }
    catch (e) { emit(VehiclesError(e.toString())); }
  }

  Future<void> _onDelete(VehicleTypeDeleteRequested event, Emitter<VehiclesState> emit) async {
    try { await _dataSource.deleteVehicleType(event.typeId); add(const VehiclesLoadRequested()); }
    catch (e) { emit(VehiclesError(e.toString())); }
  }
}
