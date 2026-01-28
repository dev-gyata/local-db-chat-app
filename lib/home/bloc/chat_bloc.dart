import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:local_db_chat_app/home/models/contact.dart';
import 'package:local_db_chat_app/home/models/conversation.dart';
import 'package:local_db_chat_app/home/models/item_fetcher.dart';
import 'package:local_db_chat_app/home/repository/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository,
       super(const ChatState()) {
    on<InitializeChatBloc>(_onInitialize);
    on<LoadConversations>(_onLoadCoversations);
    on<ConversationsListUpdated>(_onConversationsListUpdated);
    on<SeedChatData>(_onSeedChatData);
    on<LoadContacts>(_onLoadContacts);
    on<ContactsListUpdated>(_onContactsListUpdated);
  }

  final ChatRepository _chatRepository;
  StreamSubscription<List<Conversation>>? _conversationSubscription;
  StreamSubscription<List<Contact>>? _contactSubscription;

  FutureOr<void> _onLoadCoversations(
    LoadConversations event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(conversations: const ItemFetcher.loading()));
    _conversationSubscription = _chatRepository.watchConversations().listen(
      (chats) => add(
        ConversationsListUpdated(chats),
      ),
    );
  }

  FutureOr<void> _onConversationsListUpdated(
    ConversationsListUpdated event,
    Emitter<ChatState> emit,
  ) {
    emit(
      state.copyWith(conversations: ItemFetcher.success(event.conversations)),
    );
  }

  FutureOr<void> _onSeedChatData(
    SeedChatData event,
    Emitter<ChatState> emit,
  ) async {
    await _chatRepository.onInit();
  }

  @override
  Future<void> close() async {
    await _conversationSubscription?.cancel();
    await _contactSubscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onInitialize(
    InitializeChatBloc event,
    Emitter<ChatState> emit,
  ) {
    add(const SeedChatData());
    add(const LoadConversations());
    add(const LoadContacts());
  }

  FutureOr<void> _onLoadContacts(LoadContacts event, Emitter<ChatState> emit) {
    emit(state.copyWith(contacts: const ItemFetcher.loading()));
    _contactSubscription = _chatRepository.watchContacts().listen(
      (contacts) => add(
        ContactsListUpdated(contacts),
      ),
    );
  }

  FutureOr<void> _onContactsListUpdated(
    ContactsListUpdated event,
    Emitter<ChatState> emit,
  ) {
    emit(
      state.copyWith(contacts: ItemFetcher.success(event.contacts)),
    );
  }
}
