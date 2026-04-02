part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  final String userId;
  const ProfileLoadRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ProfileUpdateRequested extends ProfileEvent {
  final String userId;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? gender;

  const ProfileUpdateRequested({
    required this.userId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.gender,
  });

  @override
  List<Object?> get props => [userId, fullName, email, phoneNumber, gender];
}

class ProfileDeleteRequested extends ProfileEvent {
  final String userId;
  const ProfileDeleteRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}
