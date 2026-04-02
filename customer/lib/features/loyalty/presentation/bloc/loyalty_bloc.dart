import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_loyalty_datasource.dart';

part 'loyalty_event.dart';
part 'loyalty_state.dart';

class LoyaltyBloc extends Bloc<LoyaltyEvent, LoyaltyState> {
  final MockLoyaltyDataSource _dataSource;

  LoyaltyBloc({required MockLoyaltyDataSource dataSource})
      : _dataSource = dataSource,
        super(const LoyaltyInitial()) {
    on<LoyaltyLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(LoyaltyLoadRequested event, Emitter<LoyaltyState> emit) async {
    emit(const LoyaltyLoading());
    try {
      final credits = await _dataSource.getLoyaltyCredits(event.userId);
      final txns = await _dataSource.getTransactions(event.userId);
      emit(LoyaltyLoaded(credits: credits, transactions: txns));
    } catch (e) {
      emit(LoyaltyError(e.toString()));
    }
  }
}
