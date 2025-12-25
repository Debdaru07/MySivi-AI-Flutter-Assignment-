import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(usersProvider.notifier).addUser('User ${users.length + 1}');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('User added')));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
