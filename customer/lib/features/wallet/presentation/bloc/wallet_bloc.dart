import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../domain/repositories/wallet_repository.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository _repository;

  WalletBloc({required WalletRepository repository})
      : _repository = repository,
        super(const WalletInitial()) {
    on<WalletLoadRequested>(_onLoad);
    on<WalletAddMoneyRequested>(_onAddMoney);
    on<WalletTransactionsRequested>(_onTransactions);
  }

  Future<void> _onLoad(
    WalletLoadRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletLoading());
    final balanceResult = await _repository.getBalance(event.userId);
    final txnResult = await _repository.getTransactions(event.userId);

    balanceResult.fold(
      (failure) => emit(WalletError(mapFailureToMessage(failure))),
      (balance) {
        final transactions = txnResult.fold(
          (_) => <WalletTransactionEntity>[],
          (txns) => txns,
        );
        emit(WalletLoaded(balance: balance, transactions: transactions));
      },
    );
  }

  Future<void> _onAddMoney(
    WalletAddMoneyRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletProcessing());
    final result =
        await _repository.addMoney(event.userId, event.amount, event.method);
    result.fold(
      (failure) => emit(WalletError(mapFailureToMessage(failure))),
      (newBalance) {
        emit(WalletMoneyAdded(newBalance: newBalance, amount: event.amount));
        // Auto-reload full state
        add(WalletLoadRequested(event.userId));
      },
    );
  }

  Future<void> _onTransactions(
    WalletTransactionsRequested event,
    Emitter<WalletState> emit,
  ) async {
    final result = await _repository.getTransactions(event.userId);
    result.fold(
      (failure) => emit(WalletError(mapFailureToMessage(failure))),
      (transactions) => emit(WalletTransactionsLoaded(transactions)),
    );
  }
}
