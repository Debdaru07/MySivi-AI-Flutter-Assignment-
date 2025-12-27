import 'package:flutter_test/flutter_test.dart';
import '../../../../lib/features/chat/models/message_model.dart';
import '../../../../lib/features/users/models/user_model.dart';

void main() {
  final user = UserModel(
    id: 'u1',
    name: 'Alice',
    isOnline: true,
    lastSeen: DateTime.now(),
  );

  test('sender factory creates sender message', () {
    final msg = MessageModel.sender('Hi', user);

    expect(msg.type, MessageType.sender);
    expect(msg.status, MessageStatus.normal);
    expect(msg.text, 'Hi');
  });

  test('typing factory creates loading message', () {
    final msg = MessageModel.typing(user);

    expect(msg.status, MessageStatus.loading);
  });

  test('error factory creates error message', () {
    final msg = MessageModel.error('Oops', user);

    expect(msg.status, MessageStatus.error);
    expect(msg.text, 'Oops');
  });
}
