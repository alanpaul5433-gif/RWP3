import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../../domain/repositories/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;

  ChatBloc({required ChatRepository repository})
      : _repository = repository,
        super(const ChatInitial()) {
    on<ChatStreamStarted>(_onStream);
    on<ChatMessageSent>(_onSend);
    on<ChatInboxRequested>(_onInbox);
  }

  Future<void> _onStream(ChatStreamStarted event, Emitter<ChatState> emit) async {
    await emit.forEach(
      _repository.watchMessages(event.userId, event.otherUserId),
      onData: (result) => result.fold(
        (f) => ChatError(mapFailureToMessage(f)),
        (msgs) => ChatLoaded(messages: msgs, otherUserId: event.otherUserId),
      ),
    );
  }

  Future<void> _onSend(ChatMessageSent event, Emitter<ChatState> emit) async {
    final result = await _repository.sendMessage(
      senderId: event.senderId,
      receiverId: event.receiverId,
      message: event.message,
    );
    result.fold(
      (f) => emit(ChatError(mapFailureToMessage(f))),
      (_) {}, // Stream will auto-update
    );
  }

  Future<void> _onInbox(ChatInboxRequested event, Emitter<ChatState> emit) async {
    emit(const ChatLoading());
    final result = await _repository.getInbox(event.userId);
    result.fold(
      (f) => emit(ChatError(mapFailureToMessage(f))),
      (inbox) => emit(ChatInboxLoaded(inbox)),
    );
  }
}
