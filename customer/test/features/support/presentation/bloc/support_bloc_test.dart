import 'package:bloc_test/bloc_test.dart';
import 'package:customer/features/support/data/datasources/mock_support_datasource.dart';
import 'package:customer/features/support/presentation/bloc/support_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SupportBloc bloc;
  late MockSupportDataSource ds;

  setUp(() {
    ds = MockSupportDataSource();
    bloc = SupportBloc(dataSource: ds);
  });

  tearDown(() => bloc.close());

  const wait = Duration(seconds: 2);

  blocTest<SupportBloc, SupportState>(
    'creates support ticket',
    build: () => bloc,
    act: (bloc) => bloc.add(const SupportTicketCreateRequested(
      userId: 'u1', subject: 'Payment issue',
      description: 'I was charged twice', reason: 'Payment',
    )),
    wait: wait,
    expect: () => [const SupportCreating(), isA<SupportTicketCreated>()],
    verify: (bloc) {
      final state = bloc.state as SupportTicketCreated;
      expect(state.ticket.subject, 'Payment issue');
      expect(state.ticket.status, 'pending');
    },
  );

  blocTest<SupportBloc, SupportState>(
    'loads empty ticket list',
    build: () => bloc,
    act: (bloc) => bloc.add(const SupportTicketsLoadRequested('u1')),
    wait: wait,
    expect: () => [const SupportLoading(), isA<SupportTicketsLoaded>()],
    verify: (bloc) {
      expect((bloc.state as SupportTicketsLoaded).tickets, isEmpty);
    },
  );
}
