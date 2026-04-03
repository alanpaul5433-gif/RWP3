import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  const AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, UserEntity>> loginWithEmail(
      String email, String password) async {
    try {
      final user = await dataSource.loginWithEmail(email, password);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signupWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String gender,
    String referralCode = '',
  }) async {
    try {
      final user = await dataSource.signupWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        gender: gender,
        referralCode: referralCode,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await dataSource.resetPassword(email);
      return const Right(null);
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
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await dataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Stubs for social/phone auth — will be implemented with Firebase
  @override
  Future<Either<Failure, String>> sendPhoneOtp(String phoneNumber) async {
    return const Left(AuthFailure('Phone auth requires Firebase'));
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp(
      String verificationId, String otp) async {
    return const Left(AuthFailure('Phone auth requires Firebase'));
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() async {
    return const Left(AuthFailure('Google auth requires Firebase'));
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithApple() async {
    return const Left(AuthFailure('Apple auth requires Firebase'));
  }
}
