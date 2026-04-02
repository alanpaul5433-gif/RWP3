part of 'zones_bloc.dart';

sealed class ZonesState extends Equatable {
  const ZonesState();
  @override
  List<Object?> get props => [];
}

class ZonesInitial extends ZonesState { const ZonesInitial(); }
class ZonesLoading extends ZonesState { const ZonesLoading(); }

class ZonesLoaded extends ZonesState {
  final List<ZoneEntity> zones;
  const ZonesLoaded(this.zones);
  @override
  List<Object?> get props => [zones];
}

class ZonesError extends ZonesState {
  final String message;
  const ZonesError(this.message);
  @override
  List<Object?> get props => [message];
}
