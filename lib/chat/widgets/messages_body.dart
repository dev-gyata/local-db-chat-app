import 'package:flutter/material.dart';
import 'package:local_db_chat_app/chat/widgets/date_chip.dart';
import 'package:local_db_chat_app/chat/widgets/message_bubble.dart';
import 'package:local_db_chat_app/shared/shared.dart';

class MessagesBody extends StatelessWidget {
  MessagesBody({required this.scrollController, super.key});
  final ScrollController scrollController;

  final List<Message> messages = [
    Message(
      id: 1,
      content: 'Hey! How are you doing?',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      senderId: 2,
      status: MessageStatus.read,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final showDate =
            index == 0 ||
            !_isSameDay(
              messages[index - 1].timestamp,
              message.timestamp,
            );

        return Column(
          children: [
            if (showDate) DateChip(date: message.timestamp),
            MessageBubble(
              message: message,
            ),
          ],
        );
      },
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
