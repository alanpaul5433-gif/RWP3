import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/mock_profile_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final MockProfileDataSource dataSource;
  const ProfileRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, UserEntity>> getProfile(String userId) async {
    try {
      final user = await dataSource.getProfile(userId);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String userId,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? gender,
    String? profilePic,
  }) async {
    try {
      final user = await dataSource.updateProfile(
        userId: userId,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        gender: gender,
        profilePic: profilePic,
      );
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String userId) async {
    try {
      await dataSource.deleteAccount(userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
