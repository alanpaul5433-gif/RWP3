import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:core/core.dart';
import '../repositories/auth_repository.dart';

class SignupWithEmail implements UseCase<UserEntity, SignupParams> {
  final AuthRepository repository;
  const SignupWithEmail(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignupParams params) {
    return repository.signupWithEmail(
      email: params.email,
      password: params.password,
      fullName: params.fullName,
      gender: params.gender,
      referralCode: params.referralCode,
    );
  }
}

class SignupParams extends Equatable {
  final String email;
  final String password;
  final String fullName;
  final String gender;
  final String referralCode;

  const SignupParams({
    required this.email,
    required this.password,
    required this.fullName,
    required this.gender,
    this.referralCode = '',
  });

  @override
  List<Object?> get props => [email, password, fullName, gender, referralCode];
}
