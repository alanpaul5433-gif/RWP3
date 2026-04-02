import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

abstract class WalletRepository {
  Future<Either<Failure, double>> getBalance(String userId);
  Future<Either<Failure, double>> addMoney(String userId, double amount, String method);
  Future<Either<Failure, List<WalletTransactionEntity>>> getTransactions(String userId);
}
