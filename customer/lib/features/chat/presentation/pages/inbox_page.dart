import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../bloc/chat_bloc.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) return const Center(child: CircularProgressIndicator());
          final inbox = state is ChatInboxLoaded ? state.inbox : <InboxEntity>[];

          if (inbox.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.chat_bubble_outline, size: 48, color: colorScheme.outline),
              const SizedBox(height: 12),
              Text('No conversations', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline)),
            ]));
          }

          return ListView.separated(
            itemCount: inbox.length,
            separatorBuilder: (_, idx) => const Divider(height: 1, indent: 72),
            itemBuilder: (context, index) {
              final item = inbox[index];
              return ListTile(
                leading: CircleAvatar(backgroundColor: colorScheme.primaryContainer,
                    child: Icon(Icons.person, color: colorScheme.onPrimaryContainer)),
                title: Text(item.otherUserName.isNotEmpty ? item.otherUserName : 'User',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(item.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Text(_timeAgo(item.timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                onTap: () => context.push('/chat/${item.otherUserId}'),
              );
            },
          );
        },
      ),
    );
  }

  String _timeAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
