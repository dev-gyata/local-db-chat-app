import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:local_db_chat_app/shared/data/seed.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'local_db.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get avatarUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Rooms extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get user1Id => integer().references(Users, #id)();
  IntColumn get user2Id => integer().references(Users, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get roomId =>
      integer().references(Rooms, #id, onDelete: KeyAction.cascade)();
  IntColumn get senderId => integer().references(Users, #id)();
  TextColumn get content => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class ChatListItem {
  ChatListItem({
    required this.room,
    required this.opponent,
    required this.unreadCount,
    this.lastMessage,
  });
  final Room room;
  final User opponent;
  final Message? lastMessage;
  final int unreadCount;
}

@DriftDatabase(tables: [Users, Rooms, Messages])
class LocalDb extends _$LocalDb {
  LocalDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> seedData(int currentUserId) async {
    final existingUsers = await select(users).get();
    if (existingUsers.isNotEmpty) return;

    final userIds = <int>[];
    for (final user in Seed.userListSeed) {
      final id = await into(users).insert(
        UsersCompanion.insert(
          name: user.name,
          avatarUrl: Value(user.avatarUrl),
        ),
      );
      userIds.add(id);
    }

    for (final conv in Seed.chatListSeed(userIds)) {
      final roomId = await into(rooms).insert(
        RoomsCompanion.insert(
          user1Id: currentUserId,
          user2Id: conv.userId,
          updatedAt: Value(conv.createdAt),
        ),
      );
      final senderId = (conv.isSentByMe) ? currentUserId : conv.userId;
      await into(messages).insert(
        MessagesCompanion.insert(
          roomId: roomId,
          senderId: senderId,
          content: conv.message,
          isRead: Value(conv.unreadCount == 0),
          createdAt: Value(conv.createdAt),
        ),
      );
      final unreadCount = conv.unreadCount;
      if (unreadCount > 1) {
        for (var i = 1; i < unreadCount; i++) {
          await into(messages).insert(
            MessagesCompanion.insert(
              roomId: roomId,
              senderId: conv.userId,
              content: 'Message $i',
              isRead: const Value(false),
              createdAt: Value(
                conv.createdAt.subtract(Duration(minutes: i)),
              ),
            ),
          );
        }
      }
    }
  }

  int _getOpponentId(Room room, int currentUserId) {
    return room.user1Id == currentUserId ? room.user2Id : room.user1Id;
  }

  Future<List<ChatListItem>> getChatList(int currentUserId) async {
    final userRooms =
        await (select(rooms)
              ..where(
                (r) =>
                    r.user1Id.equals(currentUserId) |
                    r.user2Id.equals(currentUserId),
              )
              ..orderBy([(r) => OrderingTerm.desc(r.updatedAt)]))
            .get();

    final result = <ChatListItem>[];

    for (final room in userRooms) {
      final opponentId = _getOpponentId(room, currentUserId);
      final opponent = await (select(
        users,
      )..where((u) => u.id.equals(opponentId))).getSingle();

      final lastMessage =
          await (select(messages)
                ..where((m) => m.roomId.equals(room.id))
                ..orderBy([(m) => OrderingTerm.desc(m.createdAt)])
                ..limit(1))
              .getSingleOrNull();

      final unreadCount =
          await (select(messages)..where(
                (m) =>
                    m.roomId.equals(room.id) &
                    m.senderId.equals(opponentId) &
                    m.isRead.equals(false),
              ))
              .get()
              .then((msgs) => msgs.length);

      result.add(
        ChatListItem(
          room: room,
          opponent: opponent,
          lastMessage: lastMessage,
          unreadCount: unreadCount,
        ),
      );
    }

    return result;
  }

  Stream<List<ChatListItem>> watchChatList(int currentUserId) {
    return select(rooms).watch().asyncMap((_) => getChatList(currentUserId));
  }

  Stream<List<User>> watchUsers(int userId) {
    return select(users).watch();
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
      return NativeDatabase(file);
    });
  }
}
