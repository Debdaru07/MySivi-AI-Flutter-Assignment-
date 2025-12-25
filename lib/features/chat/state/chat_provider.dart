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

    final loadingMessage = MessageModel(
      text: 'Typing...',
      type: MessageType.receiver,
      timestamp: DateTime.now(),
      user: user,
      status: MessageStatus.loading,
    );

    state = [...state, loadingMessage];

    try {
      final reply = await api.fetchMessage();

      state = [
        ...state.where((m) => m != loadingMessage),
        MessageModel(
          text: reply,
          type: MessageType.receiver,
          timestamp: DateTime.now(),
          user: user,
        ),
      ];
    } catch (_) {
      state = [
        ...state.where((m) => m != loadingMessage),
        MessageModel(
          text: 'Failed to fetch message',
          type: MessageType.receiver,
          timestamp: DateTime.now(),
          user: user,
          status: MessageStatus.error,
        ),
      ];
    }
  }
}
