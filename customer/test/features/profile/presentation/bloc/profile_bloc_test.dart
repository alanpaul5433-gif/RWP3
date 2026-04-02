import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:customer/features/profile/data/datasources/mock_profile_datasource.dart';
import 'package:customer/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:customer/features/profile/domain/usecases/get_profile.dart';
import 'package:customer/features/profile/domain/usecases/update_profile.dart';
import 'package:customer/features/profile/domain/usecases/delete_account.dart';
import 'package:customer/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProfileBloc bloc;
  late MockProfileDataSource dataSource;

  final testUser = UserEntity(
    id: 'user_1',
    fullName: 'John Doe',
    email: 'john@example.com',
    phoneNumber: '+1234567890',
    gender: 'Male',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  setUp(() {
    dataSource = MockProfileDataSource();
    dataSource.seedUser(testUser);
    final repo = ProfileRepositoryImpl(dataSource: dataSource);

    bloc = ProfileBloc(
      getProfile: GetProfile(repo),
      updateProfile: UpdateProfile(repo),
      deleteAccount: DeleteAccount(repo),
    );
  });

  tearDown(() => bloc.close());

  const wait = Duration(seconds: 2);

  group('ProfileLoadRequested', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileLoaded] when user exists',
      build: () => bloc,
      act: (bloc) =>
          bloc.add(const ProfileLoadRequested(userId: 'user_1')),
      wait: wait,
      expect: () => [
        const ProfileLoading(),
        isA<ProfileLoaded>(),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileError] when user not found',
      build: () => bloc,
      act: (bloc) =>
          bloc.add(const ProfileLoadRequested(userId: 'nonexistent')),
      wait: wait,
      expect: () => [
        const ProfileLoading(),
        isA<ProfileError>(),
      ],
    );
  });

  group('ProfileUpdateRequested', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileUpdating, ProfileUpdated] on success',
      build: () => bloc,
      act: (bloc) => bloc.add(const ProfileUpdateRequested(
        userId: 'user_1',
        fullName: 'Jane Doe',
      )),
      wait: wait,
      expect: () => [
        const ProfileUpdating(),
        isA<ProfileUpdated>(),
      ],
      verify: (bloc) {
        final state = bloc.state as ProfileUpdated;
        expect(state.user.fullName, 'Jane Doe');
      },
    );
  });

  group('ProfileDeleteRequested', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoading, ProfileDeleted] on success',
      build: () => bloc,
      act: (bloc) =>
          bloc.add(const ProfileDeleteRequested(userId: 'user_1')),
      wait: wait,
      expect: () => [
        const ProfileLoading(),
        const ProfileDeleted(),
      ],
    );
  });
}
