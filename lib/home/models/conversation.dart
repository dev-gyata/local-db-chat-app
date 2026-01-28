import 'package:equatable/equatable.dart';
import 'package:local_db_chat_app/home/models/contact.dart';
import 'package:local_db_chat_app/home/models/message.dart';

class Conversation extends Equatable {
  const Conversation({
    required this.id,
    required this.opponent,
    required this.lastMessage,
    required this.unreadCount,
  });

  factory Conversation.mock() {
    return Conversation(
      id: 1,
      opponent: Contact.mock(),
      lastMessage: MessageModel.mock(),
      unreadCount: 1,
    );
  }
  final int id;
  final Contact opponent;
  final MessageModel? lastMessage;
  final int unreadCount;

  bool get isLastMessageSentByOpponent {
    return lastMessage?.senderId == opponent.id;
  }

  @override
  List<Object?> get props => [
    id,
    opponent,
    lastMessage,
  ];
}
