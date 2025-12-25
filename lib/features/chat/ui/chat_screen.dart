import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../users/models/user_model.dart';
import '../state/chat_provider.dart';
import 'message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const routeName = '/chat';

  final UserModel user;

  const ChatScreen({super.key, required this.user});

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
    final messages = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.user.name)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 12),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                return MessageBubble(message: messages[i]);
              },
            ),
          ),
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
                  icon: const Icon(Icons.send),
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
