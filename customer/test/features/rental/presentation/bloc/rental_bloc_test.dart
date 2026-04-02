import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:customer/features/rental/data/datasources/mock_rental_datasource.dart';
import 'package:customer/features/rental/data/repositories/rental_repository_impl.dart';
import 'package:customer/features/rental/presentation/bloc/rental_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RentalBloc bloc;
  late MockRentalDataSource ds;

  const pickup = LocationLatLng(latitude: 37.77, longitude: -122.41, address: 'Pickup');

  setUp(() {
    ds = MockRentalDataSource();
    bloc = RentalBloc(repository: RentalRepositoryImpl(dataSource: ds));
  });

  tearDown(() { bloc.close(); ds.dispose(); });

  blocTest<RentalBloc, RentalState>(
    'loads rental packages',
    build: () => bloc,
    act: (bloc) => bloc.add(const RentalPackagesRequested()),
    wait: const Duration(seconds: 2),
    expect: () => [
      const RentalLoading(),
      isA<RentalPackagesLoaded>(),
    ],
    verify: (bloc) {
      final state = bloc.state as RentalPackagesLoaded;
      expect(state.packages.length, 4);
      expect(state.packages.first.name, '2 Hours / 20 KM');
    },
  );

  blocTest<RentalBloc, RentalState>(
    'creates rental ride',
    build: () => bloc,
    act: (bloc) => bloc.add(RentalCreateRequested(
      customerId: 'u1', pickup: pickup,
      vehicleTypeId: 'vt_2', vehicleTypeName: 'Sedan',
      package: const RentalPackage(id: 'rp_1', name: '2H/20KM', hours: 2, km: 20, price: 200),
      paymentType: 'cash',
    )),
    wait: const Duration(seconds: 2),
    verify: (bloc) {
      expect(bloc.state, anyOf(isA<RentalPlaced>(), isA<RentalUpdated>()));
    },
  );
}
