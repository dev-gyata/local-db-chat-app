import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  const MessageModel({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.senderId,
    required this.hasReadMessage,
  });

  factory MessageModel.mock() {
    return MessageModel(
      id: 1,
      content: 'Hello',
      timestamp: DateTime(2025),
      senderId: 1,
      hasReadMessage: false,
    );
  }
  final int id;
  final String content;
  final DateTime timestamp;
  final int senderId;
  final bool hasReadMessage;

  @override
  List<Object?> get props => [id, content, timestamp, senderId];
}
