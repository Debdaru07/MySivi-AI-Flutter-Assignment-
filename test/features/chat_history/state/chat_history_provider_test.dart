import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../lib/features/chat/state/chat_provider.dart';
import '../../../../lib/features/chat_history/state/chat_history_provider.dart';
import '../../../../lib/features/chat/models/message_model.dart';
import '../../../../lib/features/users/models/user_model.dart';

class FakeChatNotifier extends ChatNotifier {
  FakeChatNotifier(Map<String, List<MessageModel>> state) : super.test(state);
}

void main() {
  final now = DateTime.now();

  final userA = UserModel(
    id: 'u1',
    name: 'Alice',
    isOnline: true,
    lastSeen: now,
  );

  final userB = UserModel(id: 'u2', name: 'Bob', isOnline: true, lastSeen: now);

  test('creates one history entry per user using last message', () {
    final container = ProviderContainer(
      overrides: [
        chatProvider.overrideWith(
          (ref) => FakeChatNotifier({
            'u1': [
              MessageModel(
                text: 'Hi',
                type: MessageType.sender,
                user: userA,
                timestamp: now.subtract(const Duration(minutes: 2)),
              ),
              MessageModel(
                text: 'Hello',
                type: MessageType.receiver,
                user: userA,
                timestamp: now,
              ),
            ],
            'u2': [
              MessageModel(
                text: 'Yo',
                type: MessageType.sender,
                user: userB,
                timestamp: now.subtract(const Duration(minutes: 1)),
              ),
            ],
          }),
        ),
      ],
    );

    final history = container.read(chatHistoryProvider);

    expect(history.length, 2);
    expect(history.first.user.id, 'u1');
    expect(history.first.lastMessage, 'Hello');

    container.dispose();
  });

  test('history sorted by most recent message', () {
    final container = ProviderContainer(
      overrides: [
        chatProvider.overrideWith(
          (ref) => FakeChatNotifier({
            'u1': [
              MessageModel(
                text: 'Old',
                type: MessageType.sender,
                user: userA,
                timestamp: now.subtract(const Duration(minutes: 10)),
              ),
            ],
            'u2': [
              MessageModel(
                text: 'New',
                type: MessageType.sender,
                user: userB,
                timestamp: now,
              ),
            ],
          }),
        ),
      ],
    );

    final history = container.read(chatHistoryProvider);

    expect(history.first.user.id, 'u2');
    expect(history.first.lastMessage, 'New');

    container.dispose();
  });
}
