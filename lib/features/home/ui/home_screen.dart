import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../users/state/users_provider.dart';
import '../state/appbar_visibility_provider.dart';
import '../state/home_tab_provider.dart';
import '../models/home_tab.dart';
import '../../users/ui/users_list_page.dart';
import '../../chat_history/ui/chat_history_page.dart';

class HomeScreen extends ConsumerWidget {
  static const routeName = '/';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(homeTabProvider);
    final isVisible = ref.watch(appBarVisibleProvider);
    final users = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mini Chat'), centerTitle: true),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: isVisible ? 56 : 0,
            child: isVisible ? _TopTabSwitcher(tab: tab) : null,
          ),
          Expanded(
            child:
                tab == HomeTab.users
                    ? const UsersListPage()
                    : const ChatHistoryPage(),
          ),
        ],
      ),
      floatingActionButton:
          tab == HomeTab.users
              ? FloatingActionButton(
                onPressed: () {
                  ref
                      .read(usersProvider.notifier)
                      .addUser('User ${users.length + 1}');

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('User added')));
                },
                child: const Icon(Icons.add),
              )
              : null,

      bottomNavigationBar: const _BottomNav(),
    );
  }
}

class _TopTabSwitcher extends ConsumerWidget {
  final HomeTab tab;

  const _TopTabSwitcher({required this.tab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SegmentedButton<HomeTab>(
        segments: const [
          ButtonSegment(value: HomeTab.users, label: Text('Users')),
          ButtonSegment(
            value: HomeTab.chatHistory,
            label: Text('Chat History'),
          ),
        ],
        selected: {tab},
        onSelectionChanged: (value) {
          ref.read(homeTabProvider.notifier).state = value.first;
        },
      ),
    );
  }
}

class _BottomNav extends ConsumerWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationBar(
      selectedIndex: 0,
      onDestinationSelected: (_) {
        // Intentionally left empty (only Home is functional)
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: 'Explore',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
