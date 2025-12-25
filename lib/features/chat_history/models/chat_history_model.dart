import '../../users/models/user_model.dart';

class ChatHistoryModel {
  final UserModel user;
  final String lastMessage;
  final DateTime time;

  ChatHistoryModel({
    required this.user,
    required this.lastMessage,
    required this.time,
  });
}
