import 'package:bloc_test/bloc_test.dart';
import 'package:customer/features/chat/data/datasources/mock_chat_datasource.dart';
import 'package:customer/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:customer/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ChatBloc bloc;
  late MockChatDataSource ds;

  setUp(() {
    ds = MockChatDataSource();
    bloc = ChatBloc(repository: ChatRepositoryImpl(dataSource: ds));
  });

  tearDown(() { bloc.close(); ds.dispose(); });

  blocTest<ChatBloc, ChatState>(
    'loads inbox',
    build: () => bloc,
    act: (bloc) => bloc.add(const ChatInboxRequested('user_1')),
    wait: const Duration(seconds: 2),
    expect: () => [
      const ChatLoading(),
      isA<ChatInboxLoaded>(),
    ],
    verify: (bloc) {
      final state = bloc.state as ChatInboxLoaded;
      expect(state.inbox.length, 1);
    },
  );
}
