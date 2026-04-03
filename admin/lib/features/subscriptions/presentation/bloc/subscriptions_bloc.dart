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
    on<SubscriptionCreateRequested>(_onCreate);
    on<SubscriptionUpdateRequested>(_onUpdate);
    on<SubscriptionDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(SubscriptionsLoadRequested event, Emitter<SubscriptionsState> emit) async {
    emit(const SubscriptionsLoading());
    try { emit(SubscriptionsLoaded(await _dataSource.getPlans())); }
    catch (e) { emit(SubscriptionsError(e.toString())); }
  }

  Future<void> _onCreate(SubscriptionCreateRequested event, Emitter<SubscriptionsState> emit) async {
    emit(const SubscriptionsLoading());
    try {
      await _dataSource.createPlan(event.plan);
      emit(SubscriptionsLoaded(await _dataSource.getPlans()));
    } catch (e) { emit(SubscriptionsError(e.toString())); }
  }

  Future<void> _onUpdate(SubscriptionUpdateRequested event, Emitter<SubscriptionsState> emit) async {
    emit(const SubscriptionsLoading());
    try {
      await _dataSource.updatePlan(event.plan);
      emit(SubscriptionsLoaded(await _dataSource.getPlans()));
    } catch (e) { emit(SubscriptionsError(e.toString())); }
  }

  Future<void> _onDelete(SubscriptionDeleteRequested event, Emitter<SubscriptionsState> emit) async {
    emit(const SubscriptionsLoading());
    try {
      await _dataSource.deletePlan(event.planId);
      emit(SubscriptionsLoaded(await _dataSource.getPlans()));
    } catch (e) { emit(SubscriptionsError(e.toString())); }
  }
}
