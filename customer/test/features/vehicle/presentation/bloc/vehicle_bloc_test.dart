import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:customer/features/vehicle/data/datasources/mock_vehicle_datasource.dart';
import 'package:customer/features/vehicle/data/repositories/vehicle_repository_impl.dart';
import 'package:customer/features/vehicle/domain/usecases/get_vehicle_types.dart';
import 'package:customer/features/vehicle/presentation/bloc/vehicle_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late VehicleBloc bloc;

  setUp(() {
    final ds = MockVehicleDataSource();
    final repo = VehicleRepositoryImpl(dataSource: ds);
    bloc = VehicleBloc(getVehicleTypes: GetVehicleTypes(repo));
  });

  tearDown(() => bloc.close());

  const wait = Duration(seconds: 2);

  blocTest<VehicleBloc, VehicleState>(
    'emits [VehicleLoading, VehicleTypesLoaded] with 4 types',
    build: () => bloc,
    act: (bloc) => bloc.add(const VehicleTypesRequested()),
    wait: wait,
    expect: () => [
      const VehicleLoading(),
      isA<VehicleTypesLoaded>(),
    ],
    verify: (bloc) {
      final state = bloc.state as VehicleTypesLoaded;
      expect(state.types.length, 4);
      expect(state.types.first.name, 'Economy');
    },
  );

  blocTest<VehicleBloc, VehicleState>(
    'emits [VehicleTypeChosen] on selection',
    build: () => bloc,
    seed: () => VehicleTypesLoaded(const []),
    act: (bloc) => bloc.add(VehicleTypeSelected(
      const VehicleTypeEntity(
        id: 'vt_1',
        name: 'Economy',
        baseFare: 30,
        perKmRate: 10,
        perMinuteRate: 1.5,
        minimumFare: 50,
      ),
    )),
    expect: () => [isA<VehicleTypeChosen>()],
  );
}
