import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mysivi_ai_assessment/features/chat/data/chat_api_service.dart';
import 'package:mysivi_ai_assessment/features/users/data/users_api_service.dart';

import '../helpers/test_app.dart';
import '../helpers/fake_users.dart';

import '../mocks/mock_users_api_service.dart';
import '../mocks/mock_chat_api_service.dart';
import '../mocks/mock_users_db_service.dart';
import '../mocks/mock_chat_db_service.dart';

import '../../lib/features/users/state/users_provider.dart';
import '../../lib/features/chat/state/chat_provider.dart';
import '../../lib/features/users/state/users_db_provider.dart';
import '../../lib/features/chat/data/chat_db_service.dart';
import '../../lib/features/users/models/user_model.dart';
import '../../lib/features/chat/models/message_model.dart';

void main() {
  late MockUsersApiService usersApi;
  late MockChatApiService chatApi;
  late MockUsersDbService usersDb;
  late MockChatDbService chatDb;

  setUpAll(() {
    registerFallbackValue(
      UserModel(
        id: 'fallback',
        name: 'Fallback User',
        lastSeen: DateTime(2025),
      ),
    );

    registerFallbackValue(<MessageModel>[]);
  });

  setUp(() {
    usersApi = MockUsersApiService();
    chatApi = MockChatApiService();
    usersDb = MockUsersDbService();
    chatDb = MockChatDbService();

    // DB init stubs
    when(() => usersDb.init()).thenAnswer((_) async {});
    when(() => usersDb.getUsers()).thenAnswer((_) async => []);
    when(() => usersDb.saveUser(any())).thenAnswer((_) async {});
    when(() => usersDb.deleteUser(any())).thenAnswer((_) async {});

    when(() => chatDb.init()).thenAnswer((_) async {});
    when(() => chatDb.getUserIds()).thenReturn(<String>[]);
    when(() => chatDb.getChat(any())).thenReturn([]);
    when(() => chatDb.saveChat(any(), any())).thenAnswer((_) async {});
  });

  testWidgets(
    'Full chat flow: add user → chat → back → history → read-only chat',
    (tester) async {
      // ---------- Arrange ----------
      final user = fakeUser();

      when(() => usersApi.fetchRandomUser()).thenAnswer((_) async => user);

      when(
        () => chatApi.fetchMessage(),
      ).thenAnswer((_) async => 'Hello from bot');

      await tester.pumpWidget(
        TestApp(
          overrides: [
            usersApiProvider.overrideWithValue(usersApi),
            chatApiProvider.overrideWithValue(chatApi),
            usersDbProvider.overrideWithValue(usersDb),
            chatDbProvider.overrideWithValue(chatDb),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // ---------- Act: Add user ----------
      expect(find.text('Mini Chat'), findsOneWidget);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // ---------- Assert: User visible ----------
      expect(find.text(user.name), findsOneWidget);

      // ---------- Act: Open chat ----------
      await tester.tap(find.text(user.name));
      await tester.pumpAndSettle();

      // ---------- Assert: Chat screen ----------
      expect(find.text(user.name), findsWidgets);
      expect(find.byType(TextField), findsOneWidget); // input visible

      // ---------- Act: Send message ----------
      await tester.enterText(find.byType(TextField), 'Hi');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump(); // sender message frame

      // Typing indicator appears
      expect(find.text('Typing...'), findsOneWidget);

      // Bot reply
      await tester.pumpAndSettle();

      // ---------- Assert: Messages ----------
      expect(find.text('Hi'), findsOneWidget);
      expect(find.text('Hello from bot'), findsOneWidget);

      // ---------- Act: Back ----------
      await tester.pageBack();
      await tester.pumpAndSettle();

      // ---------- Act: Open Chat History ----------
      await tester.tap(find.text('Chat History'));
      await tester.pumpAndSettle();

      // ---------- Assert: History entry ----------
      expect(find.text(user.name), findsOneWidget);
      expect(find.text('Hello from bot'), findsOneWidget);

      // ---------- Act: Open from history (read-only) ----------
      await tester.tap(find.text(user.name));
      await tester.pumpAndSettle();

      // ---------- Assert: Read-only chat ----------
      expect(find.text(user.name), findsWidgets);
      expect(find.byType(TextField), findsNothing); // input hidden
      expect(find.text('Hi'), findsOneWidget);
      expect(find.text('Hello from bot'), findsOneWidget);
    },
  );
}
