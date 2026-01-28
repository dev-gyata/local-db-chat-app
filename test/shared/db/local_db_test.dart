import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_db_chat_app/shared/db/local_db.dart';

void main() {
  group('LocalDB Tests', () {
    late LocalDb database;

    setUp(() {
      database = LocalDb(executor: NativeDatabase.memory());
    });

    tearDown(() async {
      await database.close();
    });

    group('seedData', () {
      test('does not seed data if users already exist', () async {
        const currentUserId = 1;

        await database
            .into(database.users)
            .insert(
              const UsersCompanion(
                id: Value(currentUserId),
                name: Value('Test User'),
              ),
            );

        final userCountBefore = await database.select(database.users).get();

        await database.seedData(currentUserId);

        final userCountAfter = await database.select(database.users).get();

        expect(userCountAfter.length, userCountBefore.length);
      });

      test('seeds data when database is empty', () async {
        const currentUserId = 1;

        await database.seedData(currentUserId);

        final users = await database.select(database.users).get();
        expect(users.length, greaterThan(0));

        final rooms = await database.select(database.rooms).get();
        expect(rooms.isNotEmpty, true);

        final messages = await database.select(database.messages).get();
        expect(messages.isNotEmpty, true);
      });
    });

    group('getChatList', () {
      test('returns empty list when user has no rooms', () async {
        const currentUserId = 1;

        await database
            .into(database.users)
            .insert(
              const UsersCompanion(
                id: Value(currentUserId),
                name: Value('User 1'),
              ),
            );

        final chatList = await database.getChatList(currentUserId);

        expect(chatList, isEmpty);
      });

      test('returns chat list items for user rooms', () async {
        const currentUserId = 1;
        const opponentUserId = 2;

        await database
            .into(database.users)
            .insert(
              const UsersCompanion(
                id: Value(currentUserId),
                name: Value('User 1'),
              ),
            );
        await database
            .into(database.users)
            .insert(
              const UsersCompanion(
                id: Value(opponentUserId),
                name: Value('User 2'),
              ),
            );

        final roomId = await database
            .into(database.rooms)
            .insert(
              RoomsCompanion.insert(
                user1Id: currentUserId,
                user2Id: opponentUserId,
              ),
            );

        await database
            .into(database.messages)
            .insert(
              MessagesCompanion.insert(
                roomId: roomId,
                senderId: opponentUserId,
                content: 'Hello',
              ),
            );

        final chatList = await database.getChatList(currentUserId);

        expect(chatList.length, 1);
        expect(chatList[0].room.id, roomId);
        expect(chatList[0].opponent.id, opponentUserId);
        expect(chatList[0].lastMessage?.content, 'Hello');
        expect(chatList[0].unreadCount, 1);
      });

      test('correctly counts unread messages', () async {
        const currentUserId = 1;
        const opponentUserId = 2;

        await database
            .into(database.users)
            .insert(
              const UsersCompanion(
                id: Value(currentUserId),
                name: Value('User 1'),
              ),
            );
        await database
            .into(database.users)
            .insert(
              const UsersCompanion(
                id: Value(opponentUserId),
                name: Value('User 2'),
              ),
            );

        final roomId = await database
            .into(database.rooms)
            .insert(
              RoomsCompanion.insert(
                user1Id: currentUserId,
                user2Id: opponentUserId,
              ),
            );

        await database
            .into(database.messages)
            .insert(
              MessagesCompanion.insert(
                roomId: roomId,
                senderId: opponentUserId,
                content: 'Message 1',
                isRead: const Value(false),
              ),
            );
        await database
            .into(database.messages)
            .insert(
              MessagesCompanion.insert(
                roomId: roomId,
                senderId: opponentUserId,
                content: 'Message 2',
                isRead: const Value(false),
              ),
            );
        await database
            .into(database.messages)
            .insert(
              MessagesCompanion.insert(
                roomId: roomId,
                senderId: currentUserId,
                content: 'My message',
                isRead: const Value(false),
              ),
            );

        final chatList = await database.getChatList(currentUserId);

        expect(chatList.length, 1);
        expect(
          chatList[0].unreadCount,
          2,
        );
      });

      test('returns ordered list by room updated time', () async {
        const currentUserId = 1;
        const user2Id = 2;
        const user3Id = 3;

        await database
            .into(database.users)
            .insert(
              const UsersCompanion(
                id: Value(currentUserId),
                name: Value('User 1'),
              ),
            );
        await database
            .into(database.users)
            .insert(
              const UsersCompanion(
                id: Value(user2Id),
                name: Value('User 2'),
              ),
            );
        await database
            .into(database.users)
            .insert(
              const UsersCompanion(
                id: Value(user3Id),
                name: Value('User 3'),
              ),
            );

        final now = DateTime.now();
        final room1Id = await database
            .into(database.rooms)
            .insert(
              RoomsCompanion.insert(
                user1Id: currentUserId,
                user2Id: user2Id,
                updatedAt: Value(now.subtract(const Duration(hours: 1))),
              ),
            );

        final room2Id = await database
            .into(database.rooms)
            .insert(
              RoomsCompanion.insert(
                user1Id: currentUserId,
                user2Id: user3Id,
                updatedAt: Value(now),
              ),
            );

        final chatList = await database.getChatList(currentUserId);

        expect(chatList.length, 2);
        expect(chatList[0].room.id, room2Id);
        expect(chatList[1].room.id, room1Id);
      });

      test(
        'returns correct opponent in both user1 and user2 positions',
        () async {
          const user1Id = 1;
          const user2Id = 2;

          // Insert users
          await database
              .into(database.users)
              .insert(
                const UsersCompanion(
                  id: Value(user1Id),
                  name: Value('User 1'),
                ),
              );
          await database
              .into(database.users)
              .insert(
                const UsersCompanion(
                  id: Value(user2Id),
                  name: Value('User 2'),
                ),
              );

          await database
              .into(database.rooms)
              .insert(
                RoomsCompanion.insert(
                  user1Id: user1Id,
                  user2Id: user2Id,
                ),
              );

          final chatListUser1 = await database.getChatList(user1Id);
          expect(chatListUser1[0].opponent.id, user2Id);

          final chatListUser2 = await database.getChatList(user2Id);
          expect(chatListUser2[0].opponent.id, user1Id);
        },
      );
    });

    group('watchChatList', () {
      test('emits chat list when database changes', () async {
        const currentUserId = 1;
        const opponentUserId = 2;

        await database
            .into(database.users)
            .insert(
              const UsersCompanion(
                id: Value(currentUserId),
                name: Value('User 1'),
              ),
            );
        await database
            .into(database.users)
            .insert(
              const UsersCompanion(
                id: Value(opponentUserId),
                name: Value('User 2'),
              ),
            );

        final chatListStream = database.watchChatList(currentUserId);

        await database
            .into(database.rooms)
            .insert(
              RoomsCompanion.insert(
                user1Id: currentUserId,
                user2Id: opponentUserId,
              ),
            );

        final chatList = await chatListStream.first;

        expect(chatList.length, 1);
      });
    });

    group('watchUsers', () {
      test('emits users list when database changes', () async {
        const userId = 1;

        final usersStream = database.watchUsers(userId);

        await database
            .into(database.users)
            .insert(
              const UsersCompanion(
                id: Value(userId),
                name: Value('User 1'),
              ),
            );

        final users = await usersStream.first;

        expect(users, isNotEmpty);
      });
    });

    group('Message cascading delete', () {
      test('deletes messages when room is deleted', () async {
        const currentUserId = 1;
        const opponentUserId = 2;

        await database
            .into(database.users)
            .insert(
              const UsersCompanion(
                id: Value(currentUserId),
                name: Value('User 1'),
              ),
            );
        await database
            .into(database.users)
            .insert(
              const UsersCompanion(
                id: Value(opponentUserId),
                name: Value('User 2'),
              ),
            );

        final roomId = await database
            .into(database.rooms)
            .insert(
              RoomsCompanion.insert(
                user1Id: currentUserId,
                user2Id: opponentUserId,
              ),
            );

        await database
            .into(database.messages)
            .insert(
              MessagesCompanion.insert(
                roomId: roomId,
                senderId: currentUserId,
                content: 'Message 1',
              ),
            );
        await database
            .into(database.messages)
            .insert(
              MessagesCompanion.insert(
                roomId: roomId,
                senderId: opponentUserId,
                content: 'Message 2',
              ),
            );

        final messages = await database.select(database.messages).get();
        expect(messages.length, 2);

        final deletedCount = await (database.delete(
          database.rooms,
        )..where((r) => r.id.equals(roomId))).go();

        expect(deletedCount, 1);
      });
    });
  });
}
