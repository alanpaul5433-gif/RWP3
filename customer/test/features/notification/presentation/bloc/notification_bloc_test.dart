import 'package:bloc_test/bloc_test.dart';
import 'package:customer/features/notification/data/datasources/mock_notification_datasource.dart';
import 'package:customer/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late NotificationBloc bloc;

  setUp(() {
    bloc = NotificationBloc(dataSource: MockNotificationDataSource());
  });

  tearDown(() => bloc.close());

  blocTest<NotificationBloc, NotificationState>(
    'loads notifications',
    build: () => bloc,
    act: (bloc) => bloc.add(const NotificationsLoadRequested('user_1')),
    wait: const Duration(seconds: 2),
    expect: () => [
      const NotificationLoading(),
      isA<NotificationsLoaded>(),
    ],
    verify: (bloc) {
      final state = bloc.state as NotificationsLoaded;
      expect(state.notifications.length, 10);
    },
  );
}
