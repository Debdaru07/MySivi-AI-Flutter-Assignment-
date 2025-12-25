import '../../users/models/user_model.dart';

enum MessageType { sender, receiver }

class MessageModel {
  final String text;
  final MessageType type;
  final DateTime timestamp;
  final UserModel user;

  MessageModel({
    required this.text,
    required this.type,
    required this.timestamp,
    required this.user,
  });
}
