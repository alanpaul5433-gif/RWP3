part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState { const ChatInitial(); }
class ChatLoading extends ChatState { const ChatLoading(); }

class ChatLoaded extends ChatState {
  final List<ChatMessageEntity> messages;
  final String otherUserId;
  const ChatLoaded({required this.messages, required this.otherUserId});
  @override
  List<Object?> get props => [messages, otherUserId];
}

class ChatInboxLoaded extends ChatState {
  final List<InboxEntity> inbox;
  const ChatInboxLoaded(this.inbox);
  @override
  List<Object?> get props => [inbox];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object?> get props => [message];
}
