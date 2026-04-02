import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> loginWithEmail(String email, String password);
  Future<Either<Failure, UserEntity>> signupWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String gender,
    String referralCode,
  });
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, String>> sendPhoneOtp(String phoneNumber);
  Future<Either<Failure, UserEntity>> verifyOtp(String verificationId, String otp);
  Future<Either<Failure, UserEntity>> loginWithGoogle();
  Future<Either<Failure, UserEntity>> loginWithApple();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity?>> getCurrentUser();
}
