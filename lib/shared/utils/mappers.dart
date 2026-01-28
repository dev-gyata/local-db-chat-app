import 'package:local_db_chat_app/home/models/contact.dart';
import 'package:local_db_chat_app/home/models/conversation.dart';
import 'package:local_db_chat_app/home/models/message.dart';
import 'package:local_db_chat_app/shared/db/local_db.dart';
import 'package:local_db_chat_app/shared/shared.dart';

abstract class Mappers {
  static Conversation mapChatListItemToConversation(
    ChatListItem chatListItem,
  ) {
    return Conversation(
      id: chatListItem.room.id,
      opponent: Mappers.mapUserToContact(chatListItem.opponent),
      lastMessage: Mappers.mapMessageToMessageModel(chatListItem.lastMessage!),
      unreadCount: chatListItem.unreadCount,
    );
  }

  static Contact mapUserToContact(User user) {
    return Contact(
      id: user.id,
      name: user.name,
      avatarUrl: user.avatarUrl ?? AppConstants.imageUrl,
    );
  }

  static MessageModel mapMessageToMessageModel(Message message) {
    return MessageModel(
      id: message.id,
      content: message.content,
      timestamp: message.createdAt,
      senderId: message.senderId,
      hasReadMessage: message.isRead,
    );
  }
}
