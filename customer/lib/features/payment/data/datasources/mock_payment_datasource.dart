import 'package:core/core.dart';

class MockPaymentDataSource {
  double _walletBalance = 50.0;

  Future<String> createPaymentIntent(double amount) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'pi_mock_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<bool> confirmPayment(String paymentIntentId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<double> getWalletBalance(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _walletBalance;
  }

  Future<double> deductWallet(String userId, double amount) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (amount > _walletBalance) {
      throw const ServerException('insufficient-funds');
    }
    _walletBalance -= amount;
    return _walletBalance;
  }
}
