import 'package:local_db_chat_app/home/models/contact.dart';
import 'package:local_db_chat_app/home/models/conversation.dart';
import 'package:local_db_chat_app/home/repository/chat_repository.dart';
import 'package:local_db_chat_app/shared/db/local_db.dart';
import 'package:local_db_chat_app/shared/utils/mappers.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({required LocalDb localDb, int currentUserId = 1})
    : _localDb = localDb,
      _currentUserId = currentUserId;

  final LocalDb _localDb;
  final int _currentUserId;

  @override
  Future<void> onInit() async {
    await _localDb.seedData(_currentUserId);
  }

  @override
  Stream<List<Conversation>> watchConversations() {
    return _localDb
        .watchChatList(_currentUserId)
        .map<List<Conversation>>(
          (chatList) =>
              chatList.map(Mappers.mapChatListItemToConversation).toList(),
        );
  }

  @override
  Stream<List<Contact>> watchContacts() {
    return _localDb
        .watchUsers(_currentUserId)
        .map<List<Contact>>(
          (users) => users.map(Mappers.mapUserToContact).toList(),
        );
  }
}
