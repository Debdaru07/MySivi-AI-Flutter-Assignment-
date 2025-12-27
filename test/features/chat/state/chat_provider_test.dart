import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../lib/features/chat/state/chat_provider.dart';
import '../../../../lib/features/chat/data/chat_api_service.dart';
import '../../../../lib/features/chat/data/chat_db_service.dart';
import '../../../../lib/features/chat/models/message_model.dart';
import '../../../../lib/features/users/models/user_model.dart';

/// -------------------- Mocks --------------------

class MockChatApiService extends Mock implements ChatApiService {}

class MockChatDbService extends Mock implements ChatDbService {}

void main() {
  late MockChatApiService chatApi;
  late MockChatDbService chatDb;
  late ProviderContainer container;

  final now = DateTime.now();

  final userA = UserModel(
    id: 'u1',
    name: 'Alice',
    isOnline: true,
    lastSeen: now,
  );

  final userB = UserModel(id: 'u2', name: 'Bob', isOnline: true, lastSeen: now);

  setUpAll(() {
    registerFallbackValue(<MessageModel>[]);
  });

  setUp(() {
    chatApi = MockChatApiService();
    chatDb = MockChatDbService();

    // DB stubs
    when(() => chatDb.init()).thenAnswer((_) async {});
    when(() => chatDb.getUserIds()).thenReturn([]);
    when(() => chatDb.getChat(any())).thenReturn([]);
    when(() => chatDb.saveChat(any(), any())).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        chatApiProvider.overrideWithValue(chatApi),
        chatDbProvider.overrideWithValue(chatDb),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  // ---------------------------------------------------------
  test('initial state is empty when DB has no chats', () {
    final state = container.read(chatProvider);
    expect(state, isEmpty);
  });

  // ---------------------------------------------------------
  test('sendMessage adds sender → typing → receiver (success)', () async {
    when(
      () => chatApi.fetchMessage(),
    ).thenAnswer((_) async => 'Hello from bot');

    final notifier = container.read(chatProvider.notifier);

    await notifier.sendMessage(userA, 'Hi');

    final messages = container.read(chatProvider)[userA.id]!;

    expect(messages.length, 2);

    expect(messages[0].type, MessageType.sender);
    expect(messages[0].text, 'Hi');

    expect(messages[1].type, MessageType.receiver);
    expect(messages[1].text, 'Hello from bot');

    verify(() => chatDb.saveChat(userA.id, any())).called(greaterThan(1));
  });

  // ---------------------------------------------------------
  test('typing indicator appears before API resolves', () async {
    final completer = Completer<String>();
    when(() => chatApi.fetchMessage()).thenAnswer((_) => completer.future);

    final notifier = container.read(chatProvider.notifier);
    final future = notifier.sendMessage(userA, 'Hello');

    final messagesMidway = container.read(chatProvider)[userA.id]!;

    expect(messagesMidway.length, 2);
    expect(messagesMidway.last.status, MessageStatus.loading);

    completer.complete('Bot reply');
    await future;

    final messagesFinal = container.read(chatProvider)[userA.id]!;

    expect(messagesFinal.any((m) => m.status == MessageStatus.loading), false);
  });

  // ---------------------------------------------------------
  test('error replaces typing message on API failure', () async {
    when(() => chatApi.fetchMessage()).thenThrow(Exception('network error'));

    final notifier = container.read(chatProvider.notifier);

    await notifier.sendMessage(userA, 'Hi');

    final messages = container.read(chatProvider)[userA.id]!;

    expect(messages.last.status, MessageStatus.error);
    expect(messages.last.text, 'Failed to fetch message');
  });

  // ---------------------------------------------------------
  test('messages are isolated per user', () async {
    when(() => chatApi.fetchMessage()).thenAnswer((_) async => 'Reply');

    final notifier = container.read(chatProvider.notifier);

    await notifier.sendMessage(userA, 'Hi A');
    await notifier.sendMessage(userB, 'Hi B');

    final chatA = container.read(chatProvider)[userA.id]!;
    final chatB = container.read(chatProvider)[userB.id]!;

    expect(chatA.first.text, 'Hi A');
    expect(chatB.first.text, 'Hi B');
  });
}
