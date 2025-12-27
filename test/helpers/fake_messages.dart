import '../../lib/features/chat/models/message_model.dart';
import '../../lib/features/users/models/user_model.dart';

MessageModel senderMsg(UserModel u, String text) =>
    MessageModel.sender(text, u);

MessageModel receiverMsg(UserModel u, String text) =>
    MessageModel.receiver(text, u);
