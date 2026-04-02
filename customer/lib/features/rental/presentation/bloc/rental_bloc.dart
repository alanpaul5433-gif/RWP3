import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../domain/repositories/rental_repository.dart';

part 'rental_event.dart';
part 'rental_state.dart';

class RentalBloc extends Bloc<RentalEvent, RentalState> {
  final RentalRepository _repository;

  RentalBloc({required RentalRepository repository})
      : _repository = repository,
        super(const RentalInitial()) {
    on<RentalPackagesRequested>(_onPackages);
    on<RentalCreateRequested>(_onCreate);
    on<RentalWatchRequested>(_onWatch);
    on<RentalCancelRequested>(_onCancel);
    on<RentalHistoryRequested>(_onHistory);
  }

  Future<void> _onPackages(RentalPackagesRequested event, Emitter<RentalState> emit) async {
    emit(const RentalLoading());
    final result = await _repository.getRentalPackages();
    result.fold(
      (f) => emit(RentalError(mapFailureToMessage(f))),
      (packages) => emit(RentalPackagesLoaded(packages)),
    );
  }

  Future<void> _onCreate(RentalCreateRequested event, Emitter<RentalState> emit) async {
    emit(const RentalCreating());
    final result = await _repository.createRentalRide(
      customerId: event.customerId,
      pickup: event.pickup,
      vehicleTypeId: event.vehicleTypeId,
      vehicleTypeName: event.vehicleTypeName,
      package: event.package,
      paymentType: event.paymentType,
    );
    result.fold(
      (f) => emit(RentalError(mapFailureToMessage(f))),
      (ride) {
        emit(RentalPlaced(ride));
        add(RentalWatchRequested(ride.id));
      },
    );
  }

  Future<void> _onWatch(RentalWatchRequested event, Emitter<RentalState> emit) async {
    await emit.forEach(
      _repository.watchRide(event.rideId),
      onData: (result) => result.fold(
        (f) => RentalError(mapFailureToMessage(f)),
        (ride) => RentalUpdated(ride),
      ),
    );
  }

  Future<void> _onCancel(RentalCancelRequested event, Emitter<RentalState> emit) async {
    final result = await _repository.cancelRide(event.rideId, event.reason);
    result.fold(
      (f) => emit(RentalError(mapFailureToMessage(f))),
      (ride) => emit(RentalCancelled(ride)),
    );
  }

  Future<void> _onHistory(RentalHistoryRequested event, Emitter<RentalState> emit) async {
    final result = await _repository.getRidesByStatus(event.customerId, event.status);
    result.fold(
      (f) => emit(RentalError(mapFailureToMessage(f))),
      (rides) => emit(RentalHistoryLoaded(rides)),
    );
  }
}
