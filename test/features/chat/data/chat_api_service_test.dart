import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../lib/features/chat/data/chat_api_service.dart';

class MockChatApiService extends Mock implements ChatApiService {}

void main() {
  test('fetchMessage returns a string', () async {
    final api = MockChatApiService();

    when(() => api.fetchMessage()).thenAnswer((_) async => 'Hello');

    final res = await api.fetchMessage();

    expect(res, isA<String>());
  });
}
