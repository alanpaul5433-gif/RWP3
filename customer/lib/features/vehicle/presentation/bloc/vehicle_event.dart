part of 'vehicle_bloc.dart';

sealed class VehicleEvent extends Equatable {
  const VehicleEvent();
  @override
  List<Object?> get props => [];
}

class VehicleTypesRequested extends VehicleEvent {
  const VehicleTypesRequested();
}

class VehicleTypeSelected extends VehicleEvent {
  final VehicleTypeEntity vehicleType;
  const VehicleTypeSelected(this.vehicleType);

  @override
  List<Object?> get props => [vehicleType];
}
