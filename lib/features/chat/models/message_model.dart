import '../../users/models/user_model.dart';

enum MessageType { sender, receiver }

enum MessageStatus { normal, loading, error }

class MessageModel {
  final String text;
  final MessageType type;
  final MessageStatus status;
  final DateTime timestamp;
  final UserModel user;

  const MessageModel({
    required this.text,
    required this.type,
    required this.timestamp,
    required this.user,
    this.status = MessageStatus.normal,
  });

  /* ------------------------------------------------------------------
   * Factory helpers (clean usage inside ChatNotifier)
   * ------------------------------------------------------------------ */

  factory MessageModel.sender(String text, UserModel user) {
    return MessageModel(
      text: text,
      type: MessageType.sender,
      timestamp: DateTime.now(),
      user: user,
    );
  }

  factory MessageModel.receiver(String text, UserModel user) {
    return MessageModel(
      text: text,
      type: MessageType.receiver,
      timestamp: DateTime.now(),
      user: user,
    );
  }

  factory MessageModel.typing(UserModel user) {
    return MessageModel(
      text: 'Typing...',
      type: MessageType.receiver,
      timestamp: DateTime.now(),
      user: user,
      status: MessageStatus.loading,
    );
  }

  factory MessageModel.error(String text, UserModel user) {
    return MessageModel(
      text: text,
      type: MessageType.receiver,
      timestamp: DateTime.now(),
      user: user,
      status: MessageStatus.error,
    );
  }

  /* ------------------------------------------------------------------
   * Serialization (Hive / local DB safe)
   * ------------------------------------------------------------------ */

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type.name,
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'user': user.toJson(),
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      text: json['text'],
      type: MessageType.values.firstWhere((e) => e.name == json['type']),
      status: MessageStatus.values.firstWhere((e) => e.name == json['status']),
      timestamp: DateTime.parse(json['timestamp']),
      user: UserModel.fromJson(Map<String, dynamic>.from(json['user'])),
    );
  }
}
