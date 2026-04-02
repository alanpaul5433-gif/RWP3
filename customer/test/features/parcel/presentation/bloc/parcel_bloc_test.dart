import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:customer/features/parcel/data/datasources/mock_parcel_datasource.dart';
import 'package:customer/features/parcel/data/repositories/parcel_repository_impl.dart';
import 'package:customer/features/parcel/presentation/bloc/parcel_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ParcelBloc bloc;
  late MockParcelDataSource ds;

  const pickup = LocationLatLng(latitude: 37.77, longitude: -122.41, address: 'Pickup');
  const drop = LocationLatLng(latitude: 37.78, longitude: -122.40, address: 'Drop');

  setUp(() {
    ds = MockParcelDataSource();
    bloc = ParcelBloc(repository: ParcelRepositoryImpl(dataSource: ds));
  });

  tearDown(() { bloc.close(); ds.dispose(); });

  blocTest<ParcelBloc, ParcelState>(
    'creates parcel ride',
    build: () => bloc,
    act: (bloc) => bloc.add(ParcelCreateRequested(
      customerId: 'u1', pickup: pickup, drop: drop,
      vehicleTypeId: 'vt_1', parcelWeight: '5kg', parcelDimension: '30x20x15',
      totalAmount: 80, paymentType: 'wallet',
    )),
    wait: const Duration(seconds: 2),
    verify: (bloc) {
      expect(bloc.state, anyOf(isA<ParcelPlaced>(), isA<ParcelUpdated>()));
    },
  );

  blocTest<ParcelBloc, ParcelState>(
    'loads empty history',
    build: () => bloc,
    act: (bloc) => bloc.add(const ParcelHistoryRequested(customerId: 'u1', status: BookingStatus.completed)),
    wait: const Duration(seconds: 2),
    expect: () => [isA<ParcelHistoryLoaded>()],
  );
}
