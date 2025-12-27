import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/avatar_initial.dart';
import '../models/message_model.dart';
import '../../../core/widgets/typing_indicator.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  bool get isSender => message.type == MessageType.sender;
  bool get showTimestamp => message.status != MessageStatus.loading;

  @override
  Widget build(BuildContext context) {
    final bubbleColor =
        isSender ? AppColors.bubbleSender : AppColors.bubbleReceiver;
    final textColor = isSender ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSender) ...[
            AvatarInitial(name: message.user.name),
            const SizedBox(width: 8),
          ],

          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft:
                      isSender
                          ? const Radius.circular(16)
                          : const Radius.circular(0),
                  bottomRight:
                      isSender
                          ? const Radius.circular(0)
                          : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    isSender
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: [
                  _buildMessageContent(textColor),
                  if (showTimestamp) ...[
                    const SizedBox(height: 4),
                    Text(
                      DateUtilsHelper.formatTime(message.timestamp),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),
          ),

          if (isSender) ...[
            const SizedBox(width: 8),
            AvatarInitial(name: 'You'),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent(Color textColor) {
    switch (message.status) {
      case MessageStatus.loading:
        return TypingIndicator(
          color: isSender ? Colors.white70 : AppColors.textSecondary,
        );

      case MessageStatus.error:
        return Text(
          message.text,
          style: TextStyle(color: textColor, fontStyle: FontStyle.italic),
        );

      case MessageStatus.normal:
        return Text(
          message.text,
          style: TextStyle(color: textColor, height: 1.4),
        );
    }
  }
}
