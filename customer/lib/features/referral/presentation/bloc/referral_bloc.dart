import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/mock_referral_datasource.dart';

part 'referral_event.dart';
part 'referral_state.dart';

class ReferralBloc extends Bloc<ReferralEvent, ReferralState> {
  final MockReferralDataSource _dataSource;

  ReferralBloc({required MockReferralDataSource dataSource})
      : _dataSource = dataSource,
        super(const ReferralInitial()) {
    on<ReferralCodeRequested>(_onCodeRequested);
  }

  Future<void> _onCodeRequested(ReferralCodeRequested event, Emitter<ReferralState> emit) async {
    emit(const ReferralLoading());
    try {
      final code = await _dataSource.getReferralCode(event.userId);
      emit(ReferralCodeLoaded(code));
    } catch (e) {
      emit(ReferralError(e.toString()));
    }
  }
}
