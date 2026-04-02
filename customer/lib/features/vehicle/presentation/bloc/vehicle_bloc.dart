import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../domain/usecases/get_vehicle_types.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final GetVehicleTypes _getVehicleTypes;

  VehicleBloc({required GetVehicleTypes getVehicleTypes})
      : _getVehicleTypes = getVehicleTypes,
        super(const VehicleInitial()) {
    on<VehicleTypesRequested>(_onVehicleTypesRequested);
    on<VehicleTypeSelected>(_onVehicleTypeSelected);
  }

  Future<void> _onVehicleTypesRequested(
    VehicleTypesRequested event,
    Emitter<VehicleState> emit,
  ) async {
    emit(const VehicleLoading());
    final result = await _getVehicleTypes(const NoParams());
    result.fold(
      (failure) => emit(VehicleError(mapFailureToMessage(failure))),
      (types) => emit(VehicleTypesLoaded(types)),
    );
  }

  void _onVehicleTypeSelected(
    VehicleTypeSelected event,
    Emitter<VehicleState> emit,
  ) {
    emit(VehicleTypeChosen(event.vehicleType));
  }
}
