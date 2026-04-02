import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_bank_datasource.dart';

part 'bank_event.dart';
part 'bank_state.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  final MockBankDataSource _dataSource;

  BankBloc({required MockBankDataSource dataSource})
      : _dataSource = dataSource,
        super(const BankInitial()) {
    on<BankAccountsLoadRequested>(_onLoad);
    on<BankAccountAddRequested>(_onAdd);
    on<BankAccountDeleteRequested>(_onDelete);
    on<WithdrawalRequested>(_onWithdraw);
    on<WithdrawalHistoryRequested>(_onHistory);
  }

  Future<void> _onLoad(BankAccountsLoadRequested event, Emitter<BankState> emit) async {
    emit(const BankLoading());
    try {
      final banks = await _dataSource.getBankAccounts(event.driverId);
      final balance = await _dataSource.getWalletBalance(event.driverId);
      emit(BankAccountsLoaded(accounts: banks, walletBalance: balance));
    } catch (e) {
      emit(BankError(e.toString()));
    }
  }

  Future<void> _onAdd(BankAccountAddRequested event, Emitter<BankState> emit) async {
    try {
      await _dataSource.addBankAccount(
        driverId: event.driverId, holderName: event.holderName,
        accountNumber: event.accountNumber, bankName: event.bankName,
        ifscCode: event.ifscCode, swiftCode: event.swiftCode,
      );
      add(BankAccountsLoadRequested(event.driverId));
    } catch (e) {
      emit(BankError(e.toString()));
    }
  }

  Future<void> _onDelete(BankAccountDeleteRequested event, Emitter<BankState> emit) async {
    try {
      await _dataSource.deleteBankAccount(event.bankId);
      add(BankAccountsLoadRequested(event.driverId));
    } catch (e) {
      emit(BankError(e.toString()));
    }
  }

  Future<void> _onWithdraw(WithdrawalRequested event, Emitter<BankState> emit) async {
    emit(const WithdrawalProcessing());
    try {
      final withdrawal = await _dataSource.requestWithdrawal(
        driverId: event.driverId, amount: event.amount, bankId: event.bankId,
      );
      emit(WithdrawalSubmitted(withdrawal));
    } on ServerException catch (e) {
      emit(BankError(e.message));
    } catch (e) {
      emit(BankError(e.toString()));
    }
  }

  Future<void> _onHistory(WithdrawalHistoryRequested event, Emitter<BankState> emit) async {
    try {
      final withdrawals = await _dataSource.getWithdrawals(event.driverId);
      emit(WithdrawalHistoryLoaded(withdrawals));
    } catch (e) {
      emit(BankError(e.toString()));
    }
  }
}
