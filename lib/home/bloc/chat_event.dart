part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class InitializeChatBloc extends ChatEvent {
  const InitializeChatBloc();

  @override
  List<Object?> get props => [];
}

class LoadConversations extends ChatEvent {
  const LoadConversations();

  @override
  List<Object?> get props => [];
}

class ConversationsListUpdated extends ChatEvent {
  const ConversationsListUpdated(this.conversations);
  final List<Conversation> conversations;

  @override
  List<Object?> get props => [conversations];
}

class LoadContacts extends ChatEvent {
  const LoadContacts();

  @override
  List<Object?> get props => [];
}

class ContactsListUpdated extends ChatEvent {
  const ContactsListUpdated(this.contacts);
  final List<Contact> contacts;

  @override
  List<Object?> get props => [contacts];
}

class SeedChatData extends ChatEvent {
  const SeedChatData();
}
