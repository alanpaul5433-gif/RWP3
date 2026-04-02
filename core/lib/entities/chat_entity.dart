import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String message;
  final String type; // text, image
  final DateTime timestamp;

  const ChatMessageEntity({
    required this.id,
    required this.senderId,
    required this.message,
    this.type = 'text',
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, senderId, timestamp];
}

class InboxEntity extends Equatable {
  final String oderId;
  final String otherUserId;
  final String otherUserName;
  final String lastMessage;
  final DateTime timestamp;
  final String senderId;

  const InboxEntity({
    required this.oderId,
    required this.otherUserId,
    this.otherUserName = '',
    required this.lastMessage,
    required this.timestamp,
    required this.senderId,
  });

  @override
  List<Object?> get props => [otherUserId, timestamp];
}
