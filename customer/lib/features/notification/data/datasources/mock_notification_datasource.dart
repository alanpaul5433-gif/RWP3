import 'package:core/core.dart';

class MockNotificationDataSource {
  final List<NotificationEntity> _notifications = List.generate(
    10,
    (i) => NotificationEntity(
      id: 'notif_$i',
      title: i % 2 == 0 ? 'Ride Completed' : 'Driver Assigned',
      body: i % 2 == 0 ? 'Your ride has been completed. Thank you!' : 'A driver has been assigned to your ride.',
      type: 'cab',
      bookingId: 'bk_$i',
      isRead: i < 5,
      createdAt: DateTime.now().subtract(Duration(hours: i * 2)),
    ),
  );

  Future<List<NotificationEntity>> getNotifications(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_notifications);
  }

  Future<void> deleteNotification(String notifId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _notifications.removeWhere((n) => n.id == notifId);
  }
}
