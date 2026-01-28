import 'package:local_db_chat_app/home/models/contact.dart';
import 'package:local_db_chat_app/home/models/conversation.dart';

abstract class ChatRepository {
  Future<void> onInit();

  Stream<List<Conversation>> watchConversations();

  Stream<List<Contact>> watchContacts();
}
