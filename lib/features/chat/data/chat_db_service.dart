import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/message_model.dart';

final chatDbProvider = Provider<ChatDbService>((ref) {
  return ChatDbService();
});

class ChatDbService {
  static const _boxName = 'chat_box';
  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  /// ✅ NEW: expose all userIds with chats
  Iterable<String> getUserIds() {
    return _box.keys.cast<String>();
  }

  List<MessageModel> getChat(String userId) {
    final data = _box.get(userId);
    if (data == null) return [];

    return (data as List)
        .map((e) => MessageModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveChat(String userId, List<MessageModel> messages) async {
    await _box.put(userId, messages.map((e) => e.toJson()).toList());
  }
}
