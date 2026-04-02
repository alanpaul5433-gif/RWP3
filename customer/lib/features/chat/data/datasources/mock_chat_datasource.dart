import 'dart:async';
import 'package:core/core.dart';

class MockChatDataSource {
  final Map<String, List<ChatMessageEntity>> _chats = {};
  final Map<String, StreamController<List<ChatMessageEntity>>> _controllers = {};

  Future<ChatMessageEntity> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
    String type = 'text',
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final key = _chatKey(senderId, receiverId);
    final msg = ChatMessageEntity(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      message: message,
      type: type,
      timestamp: DateTime.now(),
    );
    _chats.putIfAbsent(key, () => []);
    _chats[key]!.add(msg);
    _controllers[key]?.add(List.unmodifiable(_chats[key]!));
    return msg;
  }

  Stream<List<ChatMessageEntity>> watchMessages(String userId, String otherUserId) {
    final key = _chatKey(userId, otherUserId);
    _controllers[key]?.close();
    final controller = StreamController<List<ChatMessageEntity>>.broadcast();
    _controllers[key] = controller;
    controller.add(List.unmodifiable(_chats[key] ?? []));
    return controller.stream;
  }

  Future<List<InboxEntity>> getInbox(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      InboxEntity(
        oderId: 'bk_1',
        otherUserId: 'driver_1',
        otherUserName: 'Mock Driver',
        lastMessage: 'I am on my way!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        senderId: 'driver_1',
      ),
    ];
  }

  String _chatKey(String a, String b) => a.compareTo(b) < 0 ? '${a}_$b' : '${b}_$a';

  void dispose() {
    for (final c in _controllers.values) { c.close(); }
    _controllers.clear();
  }
}
