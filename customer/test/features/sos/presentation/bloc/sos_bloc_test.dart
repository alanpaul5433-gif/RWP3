import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:customer/features/sos/data/datasources/mock_sos_datasource.dart';
import 'package:customer/features/sos/presentation/bloc/sos_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SosBloc bloc;

  setUp(() {
    bloc = SosBloc(dataSource: MockSosDataSource());
  });

  tearDown(() => bloc.close());

  const wait = Duration(seconds: 2);

  blocTest<SosBloc, SosState>(
    'triggers SOS alert',
    build: () => bloc,
    act: (bloc) => bloc.add(const SosTriggered(
      userId: 'u1', bookingId: 'bk_1',
      location: LocationLatLng(latitude: 37.77, longitude: -122.41, address: 'SF'),
      contactNumber: '+1555000999',
    )),
    wait: wait,
    expect: () => [const SosProcessing(), isA<SosAlertSent>()],
    verify: (bloc) {
      final state = bloc.state as SosAlertSent;
      expect(state.alert.userId, 'u1');
      expect(state.alert.bookingId, 'bk_1');
    },
  );

  blocTest<SosBloc, SosState>(
    'loads empty SOS history',
    build: () => bloc,
    act: (bloc) => bloc.add(const SosHistoryRequested('u1')),
    wait: wait,
    expect: () => [const SosLoading(), isA<SosHistoryLoaded>()],
    verify: (bloc) {
      expect((bloc.state as SosHistoryLoaded).alerts, isEmpty);
    },
  );
}
