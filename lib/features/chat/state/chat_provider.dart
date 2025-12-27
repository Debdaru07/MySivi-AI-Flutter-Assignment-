import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chat_db_service.dart';
import '../models/message_model.dart';
import '../data/chat_api_service.dart';
import '../../users/models/user_model.dart';

final chatProvider =
    StateNotifierProvider<ChatNotifier, Map<String, List<MessageModel>>>(
      (ref) => ChatNotifier(ref.read(chatDbProvider), ChatApiService()),
    );

class ChatNotifier extends StateNotifier<Map<String, List<MessageModel>>> {
  final ChatDbService db;
  final ChatApiService api;

  ChatNotifier(this.db, this.api) : super({}) {
    _init();
  }

  Future<void> _init() async {
    await db.init();
    // Load all chats from DB
    final Map<String, List<MessageModel>> loaded = {};
    for (final userId in db.getUserIds()) {
      loaded[userId] = db.getChat(userId);
    }
    state = loaded;
  }

  List<MessageModel> getMessages(String userId) {
    return state[userId] ?? [];
  }

  Future<void> sendMessage(UserModel user, String text) async {
    final userId = user.id;
    final messages = [...getMessages(userId)];

    // 1️⃣ Sender message
    messages.add(MessageModel.sender(text, user));

    // 2️⃣ Typing indicator
    final typing = MessageModel.typing(user);
    messages.add(typing);

    state = {...state, userId: messages};
    await db.saveChat(userId, messages);

    try {
      final reply = await api.fetchMessage();

      messages
        ..remove(typing)
        ..add(MessageModel.receiver(reply, user));

      state = {...state, userId: messages};
      await db.saveChat(userId, messages);
    } catch (_) {
      messages
        ..remove(typing)
        ..add(MessageModel.error('Failed to fetch message', user));

      state = {...state, userId: messages};
      await db.saveChat(userId, messages);
    }
  }
}
