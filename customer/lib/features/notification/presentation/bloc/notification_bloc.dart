import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../data/datasources/mock_notification_datasource.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final MockNotificationDataSource _dataSource;

  NotificationBloc({required MockNotificationDataSource dataSource})
      : _dataSource = dataSource,
        super(const NotificationInitial()) {
    on<NotificationsLoadRequested>(_onLoad);
    on<NotificationDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(NotificationsLoadRequested event, Emitter<NotificationState> emit) async {
    emit(const NotificationLoading());
    try {
      final notifications = await _dataSource.getNotifications(event.userId);
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onDelete(NotificationDeleteRequested event, Emitter<NotificationState> emit) async {
    try {
      await _dataSource.deleteNotification(event.notificationId);
      add(NotificationsLoadRequested(event.userId));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
