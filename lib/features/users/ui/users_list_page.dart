import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../home/state/appbar_visibility_provider.dart';
import '../state/users_provider.dart';
import '../models/user_model.dart';
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

    if (users.isEmpty) {
      return const Center(
        child: Text(
          'No users yet',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Scaffold(
      body: ListView.builder(
        key: const PageStorageKey('users'),
        controller: _controller,
        itemCount: users.length,
        itemBuilder: (_, i) {
          final user = users[i];
          return _UserTile(user: user);
        },
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final UserModel user;

  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: _UserAvatar(user: user),
      title: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        user.isOnline
            ? 'Online'
            : 'Last seen ${_formatLastSeen(user.lastSeen)}',
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          ChatScreen.routeName,
          arguments: {'user': user},
        );
      },
    );
  }

  String _formatLastSeen(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _UserAvatar extends StatelessWidget {
  final UserModel user;

  const _UserAvatar({required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildAvatar(),
        if (user.isOnline)
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
    );
  }

  Widget _buildAvatar() {
    if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage(user.avatarUrl!),
        backgroundColor: Colors.grey.shade200,
      );
    }

    return AvatarInitial(name: user.name, radius: 22);
  }
}
