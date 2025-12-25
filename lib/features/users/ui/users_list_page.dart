import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            leading: Stack(
              children: [
                AvatarInitial(name: user.name, radius: 22),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.onlineGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            title: Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              'Online',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                ChatScreen.routeName,
                arguments: {'user': user},
              );
            },
          );
        },
      ),
    );
  }
}
