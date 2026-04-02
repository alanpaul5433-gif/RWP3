import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/delete_account.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;
  final DeleteAccount _deleteAccount;

  ProfileBloc({
    required GetProfile getProfile,
    required UpdateProfile updateProfile,
    required DeleteAccount deleteAccount,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        _deleteAccount = deleteAccount,
        super(const ProfileInitial()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfileDeleteRequested>(_onProfileDeleteRequested);
  }

  Future<void> _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    final result = await _getProfile(GetProfileParams(userId: event.userId));
    result.fold(
      (failure) => emit(ProfileError(mapFailureToMessage(failure))),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileUpdating());
    final result = await _updateProfile(UpdateProfileParams(
      userId: event.userId,
      fullName: event.fullName,
      email: event.email,
      phoneNumber: event.phoneNumber,
      gender: event.gender,
    ));
    result.fold(
      (failure) => emit(ProfileError(mapFailureToMessage(failure))),
      (user) => emit(ProfileUpdated(user)),
    );
  }

  Future<void> _onProfileDeleteRequested(
    ProfileDeleteRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    final result =
        await _deleteAccount(DeleteAccountParams(userId: event.userId));
    result.fold(
      (failure) => emit(ProfileError(mapFailureToMessage(failure))),
      (_) => emit(const ProfileDeleted()),
    );
  }
}
