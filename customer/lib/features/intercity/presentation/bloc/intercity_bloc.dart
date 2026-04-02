import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../domain/repositories/intercity_repository.dart';

part 'intercity_event.dart';
part 'intercity_state.dart';

class IntercityBloc extends Bloc<IntercityEvent, IntercityState> {
  final IntercityRepository _repository;

  IntercityBloc({required IntercityRepository repository})
      : _repository = repository,
        super(const IntercityInitial()) {
    on<IntercityCreateRequested>(_onCreate);
    on<IntercityWatchRequested>(_onWatch);
    on<IntercityCancelRequested>(_onCancel);
    on<IntercityHistoryRequested>(_onHistory);
  }

  Future<void> _onCreate(
    IntercityCreateRequested event,
    Emitter<IntercityState> emit,
  ) async {
    emit(const IntercityCreating());
    final result = await _repository.createIntercityRide(
      customerId: event.customerId,
      source: event.source,
      destination: event.destination,
      stops: event.stops,
      vehicleTypeId: event.vehicleTypeId,
      vehicleTypeName: event.vehicleTypeName,
      rideType: event.rideType,
      sharingPersons: event.sharingPersons,
      totalAmount: event.totalAmount,
      paymentType: event.paymentType,
    );
    result.fold(
      (f) => emit(IntercityError(mapFailureToMessage(f))),
      (ride) {
        emit(IntercityPlaced(ride));
        add(IntercityWatchRequested(ride.id));
      },
    );
  }

  Future<void> _onWatch(
    IntercityWatchRequested event,
    Emitter<IntercityState> emit,
  ) async {
    await emit.forEach(
      _repository.watchRide(event.rideId),
      onData: (result) => result.fold(
        (f) => IntercityError(mapFailureToMessage(f)),
        (ride) => IntercityUpdated(ride),
      ),
    );
  }

  Future<void> _onCancel(
    IntercityCancelRequested event,
    Emitter<IntercityState> emit,
  ) async {
    final result = await _repository.cancelRide(event.rideId, event.reason);
    result.fold(
      (f) => emit(IntercityError(mapFailureToMessage(f))),
      (ride) => emit(IntercityCancelled(ride)),
    );
  }

  Future<void> _onHistory(
    IntercityHistoryRequested event,
    Emitter<IntercityState> emit,
  ) async {
    final result = await _repository.getRidesByStatus(event.customerId, event.status);
    result.fold(
      (f) => emit(IntercityError(mapFailureToMessage(f))),
      (rides) => emit(IntercityHistoryLoaded(rides)),
    );
  }
}
