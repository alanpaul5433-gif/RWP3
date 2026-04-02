import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/mock_payment_datasource.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final MockPaymentDataSource dataSource;
  const PaymentRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, String>> createPaymentIntent(double amount) async {
    try {
      final intentId = await dataSource.createPaymentIntent(amount);
      return Right(intentId);
    } catch (e) {
      return Left(PaymentFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> confirmPayment(String paymentIntentId) async {
    try {
      final confirmed = await dataSource.confirmPayment(paymentIntentId);
      return Right(confirmed);
    } catch (e) {
      return Left(PaymentFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getWalletBalance(String userId) async {
    try {
      final balance = await dataSource.getWalletBalance(userId);
      return Right(balance);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> deductWallet(
      String userId, double amount) async {
    try {
      final balance = await dataSource.deductWallet(userId, amount);
      return Right(balance);
    } on ServerException catch (e) {
      return Left(PaymentFailure(e.message));
    } catch (e) {
      return Left(PaymentFailure(e.toString()));
    }
  }
}
