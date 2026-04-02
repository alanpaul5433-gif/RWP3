import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> getProfile(String userId);
  Future<Either<Failure, UserEntity>> updateProfile({
    required String userId,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? gender,
    String? profilePic,
  });
  Future<Either<Failure, void>> deleteAccount(String userId);
}
