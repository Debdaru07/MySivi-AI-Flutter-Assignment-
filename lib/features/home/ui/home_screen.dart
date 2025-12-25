import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/widgets/custom_bottom_nav.dart';
import '../../offers/ui/offers_screen.dart';
import '../../settings/ui/settings_screen.dart';
import '../../users/state/users_provider.dart';
import '../state/home_tab_provider.dart';
import '../models/home_tab.dart';
import '../../users/ui/users_list_page.dart';
import '../../chat_history/ui/chat_history_page.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/';

  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return Column(
          children: [
            _TopTabSwitcher(tab: ref.watch(homeTabProvider)),
            Expanded(
              child:
                  ref.watch(homeTabProvider) == HomeTab.users
                      ? const UsersListPage()
                      : const ChatHistoryPage(),
            ),
          ],
        );

      case 1:
        return const OffersScreen();

      case 2:
        return const SettingsScreen();

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(homeTabProvider);
    final users = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mini Chat'), centerTitle: true),
      body: _buildBody(),
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
                child: Icon(PhosphorIcons.plus()),
              )
              : null,

      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
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
          ButtonSegment(value: HomeTab.users, label: Text('Users'), icon: null),
          ButtonSegment(
            value: HomeTab.chatHistory,
            label: Text('Chat History'),
            icon: null,
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
