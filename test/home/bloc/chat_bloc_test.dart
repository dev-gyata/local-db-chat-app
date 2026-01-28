import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db_chat_app/home/bloc/chat_bloc.dart';
import 'package:local_db_chat_app/home/models/contact.dart';
import 'package:local_db_chat_app/home/models/conversation.dart';
import 'package:local_db_chat_app/home/models/item_fetcher.dart';
import 'package:local_db_chat_app/home/repository/chat_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  group('Chat Bloc', () {
    late ChatRepository chatRepository;

    setUp(() {
      chatRepository = MockChatRepository();
    });
    blocTest<ChatBloc, ChatState>(
      'emits [conversations and contacts] when initialized is added.',
      build: () => ChatBloc(chatRepository: chatRepository),
      act: (bloc) => bloc.add(const InitializeChatBloc()),
      setUp: () {
        when(() => chatRepository.watchConversations()).thenAnswer(
          (_) async* {
            yield [
              Conversation.mock(),
            ];
          },
        );
        when(() => chatRepository.watchContacts()).thenAnswer(
          (_) async* {
            yield [
              Contact.mock(),
            ];
          },
        );

        when(() => chatRepository.onInit()).thenAnswer((_) async {});
      },
      expect: () => <ChatState>[
        const ChatState(
          conversations: ItemFetcher.loading(),
          contacts: ItemFetcher.loading(),
        ),
        ChatState(
          contacts: const ItemFetcher.loading(),
          conversations: ItemFetcher.success([
            Conversation.mock(),
          ]),
        ),
        ChatState(
          contacts: ItemFetcher.success(
            [Contact.mock()],
          ),
          conversations: ItemFetcher.success([
            Conversation.mock(),
          ]),
        ),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'emits [updated conversations] when ConversationsListUpdated is added.',
      build: () => ChatBloc(chatRepository: chatRepository),
      seed: () {
        return ChatState(
          conversations: ItemFetcher.success([
            Conversation.mock(),
          ]),
        );
      },
      act: (bloc) => bloc.add(
        ConversationsListUpdated([
          Conversation.mock(),
          Conversation.mock(),
        ]),
      ),
      expect: () => <ChatState>[
        ChatState(
          conversations: ItemFetcher.success([
            Conversation.mock(),
            Conversation.mock(),
          ]),
        ),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'emits [updated contacts] when ContactsListUpdated is added.',
      build: () => ChatBloc(chatRepository: chatRepository),
      seed: () {
        return ChatState(
          contacts: ItemFetcher.success([
            Contact.mock(),
          ]),
        );
      },
      act: (bloc) => bloc.add(
        ContactsListUpdated([
          Contact.mock(),
          Contact.mock(),
        ]),
      ),
      expect: () => <ChatState>[
        ChatState(
          contacts: ItemFetcher.success([
            Contact.mock(),
            Contact.mock(),
          ]),
        ),
      ],
    );
  });
}
