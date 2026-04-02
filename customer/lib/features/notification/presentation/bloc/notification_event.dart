part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class NotificationsLoadRequested extends NotificationEvent {
  final String userId;
  const NotificationsLoadRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}

class NotificationDeleteRequested extends NotificationEvent {
  final String notificationId;
  final String userId;
  const NotificationDeleteRequested({required this.notificationId, required this.userId});
  @override
  List<Object?> get props => [notificationId, userId];
}
