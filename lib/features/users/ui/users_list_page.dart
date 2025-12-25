import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/state/appbar_visibility_provider.dart';
import '../state/users_provider.dart';
import '../../../core/widgets/avatar_initial.dart';
import '../../chat/ui/chat_screen.dart';

class UsersListPage extends ConsumerStatefulWidget {
  const UsersListPage({super.key});

  @override
  ConsumerState<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends ConsumerState<UsersListPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final notifier = ref.read(appBarVisibleProvider.notifier);

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
    final users = ref.watch(usersProvider);

    return Scaffold(
      body: ListView.builder(
        key: const PageStorageKey('users'),
        itemCount: users.length,
        itemBuilder: (_, i) {
          final user = users[i];
          return ListTile(
            leading: AvatarInitial(name: user.name),
            title: Text(user.name),
            onTap:
                () => Navigator.pushNamed(
                  context,
                  ChatScreen.routeName,
                  arguments: {'user': user},
                ),
          );
        },
      ),
    );
  }
}
