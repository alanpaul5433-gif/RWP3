import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/mock_chat_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final MockChatDataSource dataSource;
  const ChatRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
    String type = 'text',
  }) async {
    try {
      return Right(await dataSource.sendMessage(
        senderId: senderId, receiverId: receiverId, message: message, type: type,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<ChatMessageEntity>>> watchMessages(String userId, String otherUserId) {
    return dataSource.watchMessages(userId, otherUserId).map(
      (msgs) => Right<Failure, List<ChatMessageEntity>>(msgs),
    );
  }

  @override
  Future<Either<Failure, List<InboxEntity>>> getInbox(String userId) async {
    try {
      return Right(await dataSource.getInbox(userId));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
