import 'package:flutter/material.dart';

import 'package:local_db_chat_app/chat/widgets/chat_input_textfield.dart';
import 'package:local_db_chat_app/chat/widgets/messages_body.dart';
import 'package:local_db_chat_app/shared/theme/colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    required this.contactName,
    required this.contactAvatar,
    super.key,
  });
  final String contactName;
  final String contactAvatar;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // void _scrollToBottom() {
  //   Future.delayed(const Duration(milliseconds: 100), () {
  //     if (_scrollController.hasClients) {
  //       _scrollController.animateTo(
  //         _scrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.contactAvatar),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.contactName,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: MessagesBody(scrollController: _scrollController)),
          const ChatInputTextfield(),
        ],
      ),
    );
  }
}
