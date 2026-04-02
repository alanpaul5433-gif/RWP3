import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../../domain/repositories/admin_auth_repository.dart';
import '../datasources/mock_admin_auth_datasource.dart';

class AdminAuthRepositoryImpl implements AdminAuthRepository {
  final MockAdminAuthDataSource dataSource;
  const AdminAuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, AdminEntity>> loginWithEmail(
      String email, String password) async {
    try {
      final admin = await dataSource.loginWithEmail(email, password);
      return Right(admin);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await dataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminEntity?>> getCurrentAdmin() async {
    try {
      final admin = await dataSource.getCurrentAdmin();
      return Right(admin);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
