import '../../users/models/user_model.dart';

enum MessageType { sender, receiver }

enum MessageStatus { normal, loading, error }

class MessageModel {
  final String text;
  final MessageType type;
  final MessageStatus status;
  final DateTime timestamp;
  final UserModel user;

  MessageModel({
    required this.text,
    required this.type,
    required this.timestamp,
    required this.user,
    this.status = MessageStatus.normal,
  });
}
