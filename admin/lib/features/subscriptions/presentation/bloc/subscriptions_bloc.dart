import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_subscriptions_datasource.dart';

part 'subscriptions_event.dart';
part 'subscriptions_state.dart';

class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  final MockSubscriptionsDataSource _dataSource;

  SubscriptionsBloc({required MockSubscriptionsDataSource dataSource})
      : _dataSource = dataSource,
        super(const SubscriptionsInitial()) {
    on<SubscriptionsLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(SubscriptionsLoadRequested event, Emitter<SubscriptionsState> emit) async {
    emit(const SubscriptionsLoading());
    try {
      emit(SubscriptionsLoaded(await _dataSource.getPlans()));
    } catch (e) {
      emit(SubscriptionsError(e.toString()));
    }
  }
}
