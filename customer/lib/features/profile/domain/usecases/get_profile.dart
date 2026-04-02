import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:core/core.dart';
import '../repositories/profile_repository.dart';

class GetProfile implements UseCase<UserEntity, GetProfileParams> {
  final ProfileRepository repository;
  const GetProfile(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(GetProfileParams params) {
    return repository.getProfile(params.userId);
  }
}

class GetProfileParams extends Equatable {
  final String userId;
  const GetProfileParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
