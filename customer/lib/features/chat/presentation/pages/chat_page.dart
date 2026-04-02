import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/chat_bloc.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final String otherUserId;
  final String otherUserName;
  const ChatPage({super.key, required this.userId, required this.otherUserId, this.otherUserName = 'Driver'});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();

  @override
  void dispose() { _messageController.dispose(); super.dispose(); }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    context.read<ChatBloc>().add(ChatMessageSent(senderId: widget.userId, receiverId: widget.otherUserId, message: text));
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUserName)),
      body: Column(children: [
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              final messages = state is ChatLoaded ? state.messages : <ChatMessageEntity>[];
              if (messages.isEmpty) {
                return Center(child: Text('No messages yet', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline)));
              }
              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[messages.length - 1 - index];
                  final isMine = msg.senderId == widget.userId;
                  return Align(
                    alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: isMine ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMine ? 16 : 4), bottomRight: Radius.circular(isMine ? 4 : 16),
                        ),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text(msg.message, style: TextStyle(color: isMine ? colorScheme.onPrimary : colorScheme.onSurface)),
                        const SizedBox(height: 4),
                        Text('${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(fontSize: 10, color: isMine ? colorScheme.onPrimary.withValues(alpha: 0.7) : colorScheme.onSurface.withValues(alpha: 0.5))),
                      ]),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: colorScheme.surface, border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)))),
          child: SafeArea(
            child: Row(children: [
              Expanded(child: TextField(
                controller: _messageController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(hintText: 'Type a message...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                    fillColor: colorScheme.surfaceContainerHighest, filled: true, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
              )),
              const SizedBox(width: 8),
              IconButton.filled(onPressed: _sendMessage, icon: const Icon(Icons.send, size: 20)),
            ]),
          ),
        ),
      ]),
    );
  }
}
