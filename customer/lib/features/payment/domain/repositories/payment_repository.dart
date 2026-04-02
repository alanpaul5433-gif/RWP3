import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

abstract class PaymentRepository {
  Future<Either<Failure, String>> createPaymentIntent(double amount);
  Future<Either<Failure, bool>> confirmPayment(String paymentIntentId);
  Future<Either<Failure, double>> getWalletBalance(String userId);
  Future<Either<Failure, double>> deductWallet(String userId, double amount);
}
