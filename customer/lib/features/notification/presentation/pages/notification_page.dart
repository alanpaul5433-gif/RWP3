import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/notification_bloc.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) return const Center(child: CircularProgressIndicator());
          final notifications = state is NotificationsLoaded ? state.notifications : <NotificationEntity>[];

          if (notifications.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.notifications_none, size: 48, color: colorScheme.outline),
              const SizedBox(height: 12),
              Text('All caught up!', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline)),
            ]));
          }

          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (_, idx) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return Dismissible(
                key: Key(notif.id),
                direction: DismissDirection.endToStart,
                background: Container(color: colorScheme.error, alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16), child: Icon(Icons.delete, color: colorScheme.onError)),
                onDismissed: (_) => context.read<NotificationBloc>().add(
                      NotificationDeleteRequested(notificationId: notif.id, userId: 'mock_user')),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: notif.isRead ? colorScheme.surfaceContainerHighest : colorScheme.primaryContainer,
                    child: Icon(_typeIcon(notif.type), color: notif.isRead ? colorScheme.outline : colorScheme.onPrimaryContainer, size: 20),
                  ),
                  title: Text(notif.title, style: TextStyle(fontWeight: notif.isRead ? FontWeight.normal : FontWeight.w600)),
                  subtitle: Text(notif.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Text(_timeAgo(notif.createdAt), style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _typeIcon(String type) => switch (type) {
        'cab' || 'intercity' || 'parcel' || 'rental' => Icons.local_taxi,
        'chat' => Icons.chat_bubble_outline,
        'support' => Icons.support_agent,
        _ => Icons.notifications_outlined,
      };

  String _timeAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
