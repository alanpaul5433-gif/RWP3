import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:core/core.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile implements UseCase<UserEntity, UpdateProfileParams> {
  final ProfileRepository repository;
  const UpdateProfile(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) {
    return repository.updateProfile(
      userId: params.userId,
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      gender: params.gender,
      profilePic: params.profilePic,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String userId;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final String? profilePic;

  const UpdateProfileParams({
    required this.userId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.profilePic,
  });

  @override
  List<Object?> get props =>
      [userId, fullName, email, phoneNumber, gender, profilePic];
}
