import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_db_chat_app/home/bloc/chat_bloc.dart';
import 'package:local_db_chat_app/home/models/conversation.dart';
import 'package:local_db_chat_app/home/widgets/conversation_tile.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = context.select(
      (ChatBloc bloc) => bloc.state.conversations,
    );
    return conversations.when(
      success: (conversations) {
        return _ConversationsList(conversations: conversations);
      },
      failure: (error) {
        return const Center(
          child: Text('Error'),
        );
      },
      loading: () {
        final mockConversations = List.generate(
          20,
          (index) => Conversation.mock(),
        );
        return Skeletonizer(
          child: _ConversationsList(conversations: mockConversations),
        );
      },
    );
  }
}

class _ConversationsList extends StatelessWidget {
  const _ConversationsList({required this.conversations});
  final List<Conversation> conversations;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, index) {
        return ConversationTile(conversation: conversations[index]);
      },
      separatorBuilder: (_, _) => const Divider(
        height: 8,
      ),
      itemCount: conversations.length,
    );
  }
}
