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
import '../../../core/widgets/app_snackbar.dart';

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

                  AppSnackBar.show(
                    context,
                    message: 'User added',
                    icon: PhosphorIcons.userPlus(),
                  );
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
    final double totalWidth = MediaQuery.of(context).size.width * 0.67;
    final double pillWidth = totalWidth / 2;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          width: totalWidth,
          height: 44,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              /// Sliding white pill
              AnimatedAlign(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                alignment:
                    tab == HomeTab.users
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                child: Container(
                  width: pillWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              /// Labels
              Row(
                children: [
                  _TabLabel(
                    label: 'Users',
                    selected: tab == HomeTab.users,
                    onTap: () {
                      ref.read(homeTabProvider.notifier).state = HomeTab.users;
                    },
                  ),
                  _TabLabel(
                    label: 'Chat History',
                    selected: tab == HomeTab.chatHistory,
                    onTap: () {
                      ref.read(homeTabProvider.notifier).state =
                          HomeTab.chatHistory;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabLabel({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? Colors.black : Colors.grey.shade600,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
