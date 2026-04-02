part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class SettingsLoadRequested extends SettingsEvent { const SettingsLoadRequested(); }

class SettingsUpdateRequested extends SettingsEvent {
  final Map<String, dynamic> updates;
  const SettingsUpdateRequested(this.updates);
  @override
  List<Object?> get props => [updates];
}
