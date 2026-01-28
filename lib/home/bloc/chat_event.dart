part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  // coverage:ignore-start
  @override
  List<Object?> get props => [];
  // coverage:ignore-end
}

class InitializeChatBloc extends ChatEvent {
  const InitializeChatBloc();
}

class LoadConversations extends ChatEvent {
  const LoadConversations();
}

class ConversationsListUpdated extends ChatEvent {
  const ConversationsListUpdated(this.conversations);
  final List<Conversation> conversations;

  // coverage:ignore-start
  @override
  List<Object?> get props => [conversations];
  // coverage:ignore-end
}

class LoadContacts extends ChatEvent {
  const LoadContacts();
}

class ContactsListUpdated extends ChatEvent {
  const ContactsListUpdated(this.contacts);
  final List<Contact> contacts;

  // coverage:ignore-start
  @override
  List<Object?> get props => [contacts];
  // coverage:ignore-end
}

class SeedChatData extends ChatEvent {
  const SeedChatData();
}
