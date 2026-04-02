import 'package:core/core.dart';

class MockWalletDataSource {
  double _balance = 50.0;
  final List<WalletTransactionEntity> _transactions = [
    WalletTransactionEntity(
      id: 'txn_1',
      userId: 'mock_user',
      amount: 50.0,
      type: AppConstants.transactionCredit,
      note: 'Welcome bonus',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  Future<double> getBalance(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _balance;
  }

  Future<double> addMoney(String userId, double amount, String method) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _balance += amount;
    _transactions.insert(
      0,
      WalletTransactionEntity(
        id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        amount: amount,
        type: AppConstants.transactionCredit,
        note: 'Added via $method',
        transactionId: 'pi_mock_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
      ),
    );
    return _balance;
  }

  Future<List<WalletTransactionEntity>> getTransactions(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_transactions);
  }
}
