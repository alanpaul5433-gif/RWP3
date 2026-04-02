import 'package:core/core.dart';

class MockLoyaltyDataSource {
  double _loyaltyCredits = 150.0;
  final List<LoyaltyPointTransactionEntity> _transactions = [
    LoyaltyPointTransactionEntity(
      id: 'lpt_1', userId: 'mock_user', points: 50,
      action: 'earned', bookingId: 'bk_1',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    LoyaltyPointTransactionEntity(
      id: 'lpt_2', userId: 'mock_user', points: 100,
      action: 'earned', bookingId: 'bk_2',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Future<double> getLoyaltyCredits(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _loyaltyCredits;
  }

  Future<List<LoyaltyPointTransactionEntity>> getTransactions(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_transactions);
  }
}
