import 'package:equatable/equatable.dart';

class Message extends Equatable {
  const Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.status,
    required this.senderId,
  });
  final int id;
  final String content;
  final DateTime timestamp;
  final int senderId;
  final MessageStatus status;

  bool isSentByMe(int userId) {
    return userId == id;
  }

  @override
  List<Object?> get props => [
    id,
    content,
    timestamp,
    senderId,
    status,
  ];
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}
