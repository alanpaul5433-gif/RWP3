import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:core/core.dart';
import '../repositories/profile_repository.dart';

class DeleteAccount implements UseCase<void, DeleteAccountParams> {
  final ProfileRepository repository;
  const DeleteAccount(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteAccountParams params) {
    return repository.deleteAccount(params.userId);
  }
}

class DeleteAccountParams extends Equatable {
  final String userId;
  const DeleteAccountParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
