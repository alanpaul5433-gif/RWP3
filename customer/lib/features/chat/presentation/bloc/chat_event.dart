part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class ChatStreamStarted extends ChatEvent {
  final String userId;
  final String otherUserId;
  const ChatStreamStarted({required this.userId, required this.otherUserId});
  @override
  List<Object?> get props => [userId, otherUserId];
}

class ChatMessageSent extends ChatEvent {
  final String senderId;
  final String receiverId;
  final String message;
  const ChatMessageSent({required this.senderId, required this.receiverId, required this.message});
  @override
  List<Object?> get props => [senderId, receiverId, message];
}

class ChatInboxRequested extends ChatEvent {
  final String userId;
  const ChatInboxRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}
