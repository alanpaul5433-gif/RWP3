import 'package:core/core.dart';

class MockBankDataSource {
  final List<BankDetailsEntity> _banks = [];
  final List<WithdrawalEntity> _withdrawals = [];
  double _walletBalance = 250.0;

  Future<List<BankDetailsEntity>> getBankAccounts(String driverId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_banks);
  }

  Future<BankDetailsEntity> addBankAccount({
    required String driverId,
    required String holderName,
    required String accountNumber,
    required String bankName,
    String ifscCode = '',
    String swiftCode = '',
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final bank = BankDetailsEntity(
      id: 'bank_${DateTime.now().millisecondsSinceEpoch}',
      driverId: driverId,
      holderName: holderName,
      accountNumber: accountNumber,
      bankName: bankName,
      ifscCode: ifscCode,
      swiftCode: swiftCode,
      isDefault: _banks.isEmpty,
    );
    _banks.add(bank);
    return bank;
  }

  Future<void> deleteBankAccount(String bankId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _banks.removeWhere((b) => b.id == bankId);
  }

  Future<WithdrawalEntity> requestWithdrawal({
    required String driverId,
    required double amount,
    required String bankId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (amount > _walletBalance) throw const ServerException('Insufficient balance');
    final bank = _banks.firstWhere((b) => b.id == bankId, orElse: () => throw const ServerException('Bank not found'));

    _walletBalance -= amount;
    final withdrawal = WithdrawalEntity(
      id: 'wd_${DateTime.now().millisecondsSinceEpoch}',
      driverId: driverId,
      amount: amount,
      status: AppConstants.withdrawalPending,
      bankDetails: bank,
      createdAt: DateTime.now(),
    );
    _withdrawals.add(withdrawal);
    return withdrawal;
  }

  Future<List<WithdrawalEntity>> getWithdrawals(String driverId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _withdrawals.where((w) => w.driverId == driverId).toList();
  }

  Future<double> getWalletBalance(String driverId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _walletBalance;
  }
}
