import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';
import '../data/chat_api_service.dart';
import '../../users/models/user_model.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, List<MessageModel>>(
  (ref) => ChatNotifier(ChatApiService()),
);

class ChatNotifier extends StateNotifier<List<MessageModel>> {
  final ChatApiService api;

  ChatNotifier(this.api) : super([]);

  Future<void> sendMessage(UserModel user, String text) async {
    state = [
      ...state,
      MessageModel(
        text: text,
        type: MessageType.sender,
        timestamp: DateTime.now(),
        user: user,
      ),
    ];

    try {
      final reply = await api.fetchMessage();
      state = [
        ...state,
        MessageModel(
          text: reply,
          type: MessageType.receiver,
          timestamp: DateTime.now(),
          user: user,
        ),
      ];
    } catch (_) {
      state = [
        ...state,
        MessageModel(
          text: 'Failed to load message',
          type: MessageType.receiver,
          timestamp: DateTime.now(),
          user: user,
        ),
      ];
    }
  }
}
