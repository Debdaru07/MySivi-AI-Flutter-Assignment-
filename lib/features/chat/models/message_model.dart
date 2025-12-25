enum MessageType { sender, receiver }

class MessageModel {
  final String text;
  final MessageType type;
  final DateTime timestamp;

  MessageModel({
    required this.text,
    required this.type,
    required this.timestamp,
  });
}
