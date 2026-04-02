import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_sos_datasource.dart';

part 'sos_event.dart';
part 'sos_state.dart';

class SosBloc extends Bloc<SosEvent, SosState> {
  final MockSosDataSource _dataSource;

  SosBloc({required MockSosDataSource dataSource})
      : _dataSource = dataSource,
        super(const SosInitial()) {
    on<SosTriggered>(_onTrigger);
    on<SosHistoryRequested>(_onHistory);
  }

  Future<void> _onTrigger(SosTriggered event, Emitter<SosState> emit) async {
    emit(const SosProcessing());
    try {
      final alert = await _dataSource.triggerSos(
        userId: event.userId,
        bookingId: event.bookingId,
        location: event.location,
        contactNumber: event.contactNumber,
      );
      emit(SosAlertSent(alert));
    } catch (e) {
      emit(SosError(e.toString()));
    }
  }

  Future<void> _onHistory(SosHistoryRequested event, Emitter<SosState> emit) async {
    emit(const SosLoading());
    try {
      final alerts = await _dataSource.getAlerts(event.userId);
      emit(SosHistoryLoaded(alerts));
    } catch (e) {
      emit(SosError(e.toString()));
    }
  }
}
