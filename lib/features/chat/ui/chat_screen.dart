import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../users/models/user_model.dart';
import '../state/chat_provider.dart';
import 'message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const routeName = '/chat';

  final UserModel user;
  final bool readOnly;
  const ChatScreen({super.key, required this.user, this.readOnly = false});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(
      chatProvider.select((map) => map[widget.user.id] ?? []),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            _ChatAvatar(user: widget.user),
            const SizedBox(width: 8),
            Text(widget.user.name),
          ],
        ),
        leading: IconButton(
          icon: Icon(PhosphorIcons.caretLeft()),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                messages.isEmpty
                    ? const Center(
                      child: Text(
                        'Start the conversation 👋',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 12),
                      itemCount: messages.length,
                      itemBuilder: (_, i) {
                        return MessageBubble(message: messages[i]);
                      },
                    ),
          ),
          if (!widget.readOnly)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(PhosphorIcons.paperPlaneTilt()),
                    onPressed: () async {
                      final text = _textController.text.trim();
                      if (text.isEmpty) return;

                      await ref
                          .read(chatProvider.notifier)
                          .sendMessage(widget.user, text);

                      _textController.clear();

                      // ✅ Auto-scroll after rebuild
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!_scrollController.hasClients) return;
                        _scrollController.jumpTo(
                          _scrollController.position.maxScrollExtent,
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ChatAvatar extends StatelessWidget {
  final UserModel user;

  const _ChatAvatar({required this.user});

  @override
  Widget build(BuildContext context) {
    if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(user.avatarUrl!),
        backgroundColor: Colors.grey.shade200,
      );
    }

    return CircleAvatar(
      radius: 16,
      backgroundColor: AppColors.primary,
      child: Text(
        user.initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
