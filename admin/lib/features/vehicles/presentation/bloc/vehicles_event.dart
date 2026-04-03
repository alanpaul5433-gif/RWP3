part of 'vehicles_bloc.dart';

sealed class VehiclesEvent extends Equatable {
  const VehiclesEvent();
  @override
  List<Object?> get props => [];
}

class VehiclesLoadRequested extends VehiclesEvent { const VehiclesLoadRequested(); }

class VehicleTypeCreateRequested extends VehiclesEvent {
  final VehicleTypeEntity type;
  const VehicleTypeCreateRequested(this.type);
  @override
  List<Object?> get props => [type];
}

class VehicleTypeUpdateRequested extends VehiclesEvent {
  final VehicleTypeEntity type;
  const VehicleTypeUpdateRequested(this.type);
  @override
  List<Object?> get props => [type];
}

class VehicleTypeDeleteRequested extends VehiclesEvent {
  final String typeId;
  const VehicleTypeDeleteRequested(this.typeId);
  @override
  List<Object?> get props => [typeId];
}
