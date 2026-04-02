import 'package:bloc_test/bloc_test.dart';
import 'package:driver/features/auth/data/datasources/mock_driver_auth_datasource.dart';
import 'package:driver/features/auth/presentation/bloc/driver_auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DriverAuthBloc bloc;

  setUp(() {
    bloc = DriverAuthBloc(dataSource: MockDriverAuthDataSource());
  });

  tearDown(() => bloc.close());

  const wait = Duration(seconds: 2);

  blocTest<DriverAuthBloc, DriverAuthState>(
    'emits [Loading, Unauthenticated] on check with no user',
    build: () => bloc,
    act: (bloc) => bloc.add(const DriverAuthCheckRequested()),
    wait: wait,
    expect: () => [const DriverAuthLoading(), const DriverUnauthenticated()],
  );

  blocTest<DriverAuthBloc, DriverAuthState>(
    'emits [Loading, Authenticated] on login success',
    build: () => bloc,
    act: (bloc) => bloc.add(const DriverEmailLoginRequested(email: 'driver@test.com', password: 'password123')),
    wait: wait,
    expect: () => [const DriverAuthLoading(), isA<DriverAuthenticated>()],
  );

  blocTest<DriverAuthBloc, DriverAuthState>(
    'emits [Loading, Error] on login failure',
    build: () => bloc,
    act: (bloc) => bloc.add(const DriverEmailLoginRequested(email: 'driver@test.com', password: '123')),
    wait: wait,
    expect: () => [const DriverAuthLoading(), isA<DriverAuthError>()],
  );
}
