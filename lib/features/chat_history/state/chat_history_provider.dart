import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../chat/state/chat_provider.dart';
import '../models/chat_history_model.dart';
import '../../chat/models/message_model.dart';

final chatHistoryProvider = Provider<List<ChatHistoryModel>>((ref) {
  final chatMap = ref.watch(chatProvider);

  final List<ChatHistoryModel> history = [];

  chatMap.forEach((userId, messages) {
    if (messages.isEmpty) return;

    final MessageModel lastMessage = messages.last;

    history.add(
      ChatHistoryModel(
        user: lastMessage.user,
        lastMessage: lastMessage.text,
        time: lastMessage.timestamp,
      ),
    );
  });

  history.sort((a, b) => b.time.compareTo(a.time));
  return history;
});
