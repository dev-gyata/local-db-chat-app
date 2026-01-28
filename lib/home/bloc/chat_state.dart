part of 'chat_bloc.dart';

final class ChatState extends Equatable {
  const ChatState({
    this.conversations = const ItemFetcher.initial(),
    this.contacts = const ItemFetcher.initial(),
  });

  final ItemFetcher<List<Conversation>> conversations;
  final ItemFetcher<List<Contact>> contacts;

  ChatState copyWith({
    ItemFetcher<List<Conversation>>? conversations,
    ItemFetcher<List<Contact>>? contacts,
  }) {
    return ChatState(
      conversations: conversations ?? this.conversations,
      contacts: contacts ?? this.contacts,
    );
  }

  @override
  List<Object> get props => [
    conversations,
    contacts,
  ];
}
