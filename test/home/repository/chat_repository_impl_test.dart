import 'package:flutter_test/flutter_test.dart';
import 'package:local_db_chat_app/home/models/contact.dart';
import 'package:local_db_chat_app/home/models/conversation.dart';
import 'package:local_db_chat_app/home/repository/chat_repository_impl.dart';
import 'package:local_db_chat_app/shared/db/local_db.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalDb extends Mock implements LocalDb {}

void main() {
  group('Chat Repository Impl', () {
    late ChatRepositoryImpl chatRepository;
    late LocalDb localDb;
    late final List<ChatListItem> chatList;
    late final List<User> usersList;

    setUpAll(() {
      localDb = MockLocalDb();
      chatRepository = ChatRepositoryImpl(localDb: localDb);
      usersList = List.generate(
        10,
        (_) => User.fromJson({
          'id': 1,
          'name': 'John Doe',
          'avatarUrl': 'https://i.pravatar.cc/150?img=1',
          'createdAt': '2023-01-01T00:00:00.000Z',
        }),
      );
      chatList = List.generate(
        10,
        (_) => ChatListItem(
          room: Room.fromJson({
            'id': 1,
            'user1Id': 1,
            'user2Id': 2,
            'createdAt': '2023-01-01T00:00:00.000Z',
            'updatedAt': '2023-01-01T00:00:00.000Z',
          }),
          opponent: User.fromJson({
            'id': 1,
            'name': 'John Doe',
            'avatarUrl': 'https://i.pravatar.cc/150?img=1',
            'createdAt': '2023-01-01T00:00:00.000Z',
          }),
          unreadCount: 1,
        ),
      );
    });
    test('Should call seed data when onInit is called', () async {
      when(() => localDb.seedData(any())).thenAnswer((_) async {});
      await chatRepository.onInit();
      verify(() => localDb.seedData(any())).called(1);
    });

    test('Should call watch conversations and yields a stream of conversation '
        'list when '
        'watchConversations is called', () async {
      when(() => localDb.watchChatList(any())).thenAnswer((_) async* {
        yield* Stream.value(chatList);
      });
      final response = chatRepository.watchConversations();
      verify(() => localDb.watchChatList(any())).called(1);
      expect(response, isA<Stream<List<Conversation>>>());
    });

    test('Should call watch contacts and yields a stream of contact list '
        'when watchContacts is called', () async {
      when(() => localDb.watchUsers(any())).thenAnswer((_) async* {
        yield* Stream.value(usersList);
      });
      final response = chatRepository.watchContacts();
      verify(() => localDb.watchUsers(any())).called(1);
      expect(response, isA<Stream<List<Contact>>>());
    });
  });
}
