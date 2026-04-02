part of 'vehicle_bloc.dart';

sealed class VehicleState extends Equatable {
  const VehicleState();
  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {
  const VehicleInitial();
}

class VehicleLoading extends VehicleState {
  const VehicleLoading();
}

class VehicleTypesLoaded extends VehicleState {
  final List<VehicleTypeEntity> types;
  const VehicleTypesLoaded(this.types);

  @override
  List<Object?> get props => [types];
}

class VehicleTypeChosen extends VehicleState {
  final VehicleTypeEntity vehicleType;
  const VehicleTypeChosen(this.vehicleType);

  @override
  List<Object?> get props => [vehicleType];
}

class VehicleError extends VehicleState {
  final String message;
  const VehicleError(this.message);

  @override
  List<Object?> get props => [message];
}
