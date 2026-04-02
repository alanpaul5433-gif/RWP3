import 'package:dartz/dartz.dart';
import 'package:core/core.dart';

abstract class ChatRepository {
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
    String type,
  });
  Stream<Either<Failure, List<ChatMessageEntity>>> watchMessages(
      String userId, String otherUserId);
  Future<Either<Failure, List<InboxEntity>>> getInbox(String userId);
}
