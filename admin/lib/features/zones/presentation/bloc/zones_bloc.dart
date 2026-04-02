import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_zones_datasource.dart';

part 'zones_event.dart';
part 'zones_state.dart';

class ZonesBloc extends Bloc<ZonesEvent, ZonesState> {
  final MockZonesDataSource _dataSource;

  ZonesBloc({required MockZonesDataSource dataSource})
      : _dataSource = dataSource,
        super(const ZonesInitial()) {
    on<ZonesLoadRequested>(_onLoad);
    on<ZoneCreateRequested>(_onCreate);
    on<ZoneDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(ZonesLoadRequested event, Emitter<ZonesState> emit) async {
    emit(const ZonesLoading());
    try {
      emit(ZonesLoaded(await _dataSource.getZones()));
    } catch (e) {
      emit(ZonesError(e.toString()));
    }
  }

  Future<void> _onCreate(ZoneCreateRequested event, Emitter<ZonesState> emit) async {
    try {
      await _dataSource.createZone(event.zone);
      add(const ZonesLoadRequested());
    } catch (e) {
      emit(ZonesError(e.toString()));
    }
  }

  Future<void> _onDelete(ZoneDeleteRequested event, Emitter<ZonesState> emit) async {
    try {
      await _dataSource.deleteZone(event.zoneId);
      add(const ZonesLoadRequested());
    } catch (e) {
      emit(ZonesError(e.toString()));
    }
  }
}
