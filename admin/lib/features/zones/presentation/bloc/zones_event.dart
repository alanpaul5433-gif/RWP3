part of 'zones_bloc.dart';

sealed class ZonesEvent extends Equatable {
  const ZonesEvent();
  @override
  List<Object?> get props => [];
}

class ZonesLoadRequested extends ZonesEvent { const ZonesLoadRequested(); }

class ZoneCreateRequested extends ZonesEvent {
  final ZoneEntity zone;
  const ZoneCreateRequested(this.zone);
  @override
  List<Object?> get props => [zone];
}

class ZoneDeleteRequested extends ZonesEvent {
  final String zoneId;
  const ZoneDeleteRequested(this.zoneId);
  @override
  List<Object?> get props => [zoneId];
}

class ZoneToggleRequested extends ZonesEvent {
  final String zoneId;
  const ZoneToggleRequested(this.zoneId);
  @override
  List<Object?> get props => [zoneId];
}
