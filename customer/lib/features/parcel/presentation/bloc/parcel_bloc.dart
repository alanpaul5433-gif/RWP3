import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../domain/repositories/parcel_repository.dart';

part 'parcel_event.dart';
part 'parcel_state.dart';

class ParcelBloc extends Bloc<ParcelEvent, ParcelState> {
  final ParcelRepository _repository;

  ParcelBloc({required ParcelRepository repository})
      : _repository = repository,
        super(const ParcelInitial()) {
    on<ParcelCreateRequested>(_onCreate);
    on<ParcelWatchRequested>(_onWatch);
    on<ParcelCancelRequested>(_onCancel);
    on<ParcelHistoryRequested>(_onHistory);
  }

  Future<void> _onCreate(ParcelCreateRequested event, Emitter<ParcelState> emit) async {
    emit(const ParcelCreating());
    final result = await _repository.createParcelRide(
      customerId: event.customerId, pickup: event.pickup, drop: event.drop,
      vehicleTypeId: event.vehicleTypeId, vehicleTypeName: event.vehicleTypeName,
      parcelWeight: event.parcelWeight, parcelDimension: event.parcelDimension,
      totalAmount: event.totalAmount, paymentType: event.paymentType,
    );
    result.fold(
      (f) => emit(ParcelError(mapFailureToMessage(f))),
      (ride) {
        emit(ParcelPlaced(ride));
        add(ParcelWatchRequested(ride.id));
      },
    );
  }

  Future<void> _onWatch(ParcelWatchRequested event, Emitter<ParcelState> emit) async {
    await emit.forEach(
      _repository.watchRide(event.rideId),
      onData: (result) => result.fold(
        (f) => ParcelError(mapFailureToMessage(f)),
        (ride) => ParcelUpdated(ride),
      ),
    );
  }

  Future<void> _onCancel(ParcelCancelRequested event, Emitter<ParcelState> emit) async {
    final result = await _repository.cancelRide(event.rideId, event.reason);
    result.fold(
      (f) => emit(ParcelError(mapFailureToMessage(f))),
      (ride) => emit(ParcelCancelled(ride)),
    );
  }

  Future<void> _onHistory(ParcelHistoryRequested event, Emitter<ParcelState> emit) async {
    final result = await _repository.getRidesByStatus(event.customerId, event.status);
    result.fold(
      (f) => emit(ParcelError(mapFailureToMessage(f))),
      (rides) => emit(ParcelHistoryLoaded(rides)),
    );
  }
}
