part of 'vehicles_bloc.dart';

sealed class VehiclesState extends Equatable {
  const VehiclesState();
  @override
  List<Object?> get props => [];
}

class VehiclesInitial extends VehiclesState { const VehiclesInitial(); }
class VehiclesLoading extends VehiclesState { const VehiclesLoading(); }

class VehiclesLoaded extends VehiclesState {
  final List<VehicleTypeEntity> types;
  final List<Map<String, String>> brands;
  const VehiclesLoaded({required this.types, required this.brands});
  @override
  List<Object?> get props => [types, brands];
}

class VehiclesError extends VehiclesState {
  final String message;
  const VehiclesError(this.message);
  @override
  List<Object?> get props => [message];
}
