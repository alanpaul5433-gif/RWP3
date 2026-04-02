import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/mock_wallet_datasource.dart';

class WalletRepositoryImpl implements WalletRepository {
  final MockWalletDataSource dataSource;
  const WalletRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, double>> getBalance(String userId) async {
    try {
      return Right(await dataSource.getBalance(userId));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> addMoney(
      String userId, double amount, String method) async {
    try {
      return Right(await dataSource.addMoney(userId, amount, method));
    } catch (e) {
      return Left(PaymentFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WalletTransactionEntity>>> getTransactions(
      String userId) async {
    try {
      return Right(await dataSource.getTransactions(userId));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
