import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

abstract class AdminAuthRepository {
  Future<Either<Failure, AdminEntity>> loginWithEmail(
      String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AdminEntity?>> getCurrentAdmin();
}
