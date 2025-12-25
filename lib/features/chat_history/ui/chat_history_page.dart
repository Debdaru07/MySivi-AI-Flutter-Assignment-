import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/avatar_initial.dart';
import '../../chat/ui/chat_screen.dart';
import '../../home/state/appbar_visibility_provider.dart';
import '../state/chat_history_provider.dart';

class ChatHistoryPage extends ConsumerStatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  ConsumerState<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends ConsumerState<ChatHistoryPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final container = ProviderScope.containerOf(context);
    final notifier = container.read(appBarVisibleProvider.notifier);

    if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
      notifier.state = false;
    } else if (_controller.position.userScrollDirection ==
        ScrollDirection.forward) {
      notifier.state = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final history = ref.watch(chatHistoryProvider);

    if (history.isEmpty) {
      return const Center(child: Text('No chats yet'));
    }

    return ListView.builder(
      key: const PageStorageKey('chatHistory'),
      itemCount: history.length,
      itemBuilder: (_, i) {
        final chat = history[i];

        return ListTile(
          leading: AvatarInitial(name: chat.user.name),
          title: Text(chat.user.name),
          subtitle: Text(
            chat.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            DateUtilsHelper.formatRelative(chat.time),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              ChatScreen.routeName,
              arguments: {'user': chat.user},
            );
          },
        );
      },
    );
  }
}
