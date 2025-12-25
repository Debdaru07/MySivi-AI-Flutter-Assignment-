import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../chat/state/chat_provider.dart';
import '../models/chat_history_model.dart';

final chatHistoryProvider = Provider<List<ChatHistoryModel>>((ref) {
  final messages = ref.watch(chatProvider);

  final Map<String, ChatHistoryModel> historyMap = {};

  for (final msg in messages) {
    historyMap[msg.user.id] = ChatHistoryModel(
      user: msg.user,
      lastMessage: msg.text,
      time: msg.timestamp,
    );
  }

  return historyMap.values.toList()..sort((a, b) => b.time.compareTo(a.time));
});
