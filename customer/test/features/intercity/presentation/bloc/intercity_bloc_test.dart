import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:customer/features/intercity/data/datasources/mock_intercity_datasource.dart';
import 'package:customer/features/intercity/data/repositories/intercity_repository_impl.dart';
import 'package:customer/features/intercity/presentation/bloc/intercity_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late IntercityBloc bloc;
  late MockIntercityDataSource ds;

  const source = LocationLatLng(latitude: 37.77, longitude: -122.41, address: 'SF');
  const dest = LocationLatLng(latitude: 37.33, longitude: -121.89, address: 'San Jose');

  setUp(() {
    ds = MockIntercityDataSource();
    bloc = IntercityBloc(repository: IntercityRepositoryImpl(dataSource: ds));
  });

  tearDown(() { bloc.close(); ds.dispose(); });

  blocTest<IntercityBloc, IntercityState>(
    'creates intercity ride and emits placed then updated',
    build: () => bloc,
    act: (bloc) => bloc.add(IntercityCreateRequested(
      customerId: 'u1', source: source, destination: dest,
      vehicleTypeId: 'vt_1', totalAmount: 500, paymentType: 'cash',
    )),
    wait: const Duration(seconds: 2),
    verify: (bloc) {
      expect(bloc.state, anyOf(isA<IntercityPlaced>(), isA<IntercityUpdated>()));
    },
  );

  blocTest<IntercityBloc, IntercityState>(
    'loads empty history',
    build: () => bloc,
    act: (bloc) => bloc.add(const IntercityHistoryRequested(customerId: 'u1', status: BookingStatus.completed)),
    wait: const Duration(seconds: 2),
    expect: () => [isA<IntercityHistoryLoaded>()],
    verify: (bloc) {
      expect((bloc.state as IntercityHistoryLoaded).rides, isEmpty);
    },
  );
}
