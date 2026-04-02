import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/mock_settings_datasource.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final MockSettingsDataSource _dataSource;

  SettingsBloc({required MockSettingsDataSource dataSource})
      : _dataSource = dataSource,
        super(const SettingsInitial()) {
    on<SettingsLoadRequested>(_onLoad);
    on<SettingsUpdateRequested>(_onUpdate);
  }

  Future<void> _onLoad(SettingsLoadRequested event, Emitter<SettingsState> emit) async {
    emit(const SettingsLoading());
    try {
      emit(SettingsLoaded(await _dataSource.getSettings()));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> _onUpdate(SettingsUpdateRequested event, Emitter<SettingsState> emit) async {
    try {
      final updated = await _dataSource.updateSettings(event.updates);
      emit(SettingsUpdated(updated));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}
