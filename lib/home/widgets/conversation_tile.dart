import 'package:flutter/material.dart';
import 'package:local_db_chat_app/home/models/conversation.dart';
import 'package:local_db_chat_app/shared/theme/colors.dart';
import 'package:local_db_chat_app/shared/widgets/image_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationTile extends StatelessWidget {
  const ConversationTile({required this.conversation, super.key});
  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 8,
      ),
      child: Row(
        children: [
          ImageAvatar(
            imageUrl: conversation.opponent.avatarUrl,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversation.opponent.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  conversation.lastMessage?.content ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                timeago.format(
                  conversation.lastMessage?.timestamp ?? DateTime.now(),
                ),
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 10),
              ),
              const SizedBox(height: 8),
              Builder(
                builder: (context) {
                  return switch (conversation.isLastMessageSentByOpponent) {
                    true when conversation.unreadCount > 0 => CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.ufoGreen,
                      child: Text(
                        conversation.unreadCount.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    false
                        when conversation.lastMessage?.hasReadMessage ??
                            false =>
                      const Icon(Icons.done_all, color: AppColors.blue),
                    false => const Icon(
                      Icons.check,
                      color: AppColors.textMuted,
                    ),
                    _ => const SizedBox.shrink(),
                  };
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
