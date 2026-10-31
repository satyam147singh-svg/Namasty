import 'package:flutter/material.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../calls/presentation/screens/calls_screen.dart';
import '../../../chat/presentation/screens/chat_list_screen.dart';
import '../../../groups/presentation/screens/create_group_screen.dart';
import '../../../groups/presentation/screens/groups_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../status/presentation/screens/create_status_screen.dart';
import '../../../status/presentation/screens/status_screen.dart';
import '../../domain/navigation_item.dart';
import 'namasty_bottom_nav_bar.dart';

/// Main Shell Screen with Floating Pill Bottom Navigation Bar & IndexedStack
/// Maintains state & scroll position for all 5 tabs. No drawer or hamburger menu.
class NamastyShell extends StatefulWidget {
  final int initialIndex;

  const NamastyShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<NamastyShell> createState() => _NamastyShellState();
}

class _NamastyShellState extends State<NamastyShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    return Scaffold(
      backgroundColor: colors.background,
      // IndexedStack preserves state & scroll position across all 5 tabs
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ChatListScreen(),
          StatusScreen(),
          GroupsScreen(),
          CallsScreen(),
          ProfileScreen(),
        ],
      ),
      // Rounded-square FAB positioned floating above the bottom bar
      floatingActionButton: _buildFab(colors),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // Floating pill bottom navigation bar
      bottomNavigationBar: NamastyBottomNavBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
        unreadChats: 2,
        unreadGroups: 3,
        missedCalls: 1,
      ),
    );
  }

  Widget? _buildFab(NamastyColors colors) {
    switch (_currentIndex) {
      case 0: // Chats tab
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: FloatingActionButton(
            heroTag: 'fab_chats',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Start a new chat')),
              );
            },
            tooltip: 'New Chat',
            child: const Icon(Icons.edit_rounded),
          ),
        );
      case 1: // Status tab
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: FloatingActionButton(
            heroTag: 'fab_status',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateStatusScreen()),
              );
            },
            tooltip: 'Add Status',
            child: const Icon(Icons.camera_alt_rounded),
          ),
        );
      case 2: // Groups tab
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: FloatingActionButton(
            heroTag: 'fab_groups',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateGroupScreen()),
              );
            },
            tooltip: 'New Group',
            child: const Icon(Icons.group_add_rounded),
          ),
        );
      case 3: // Calls tab
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: FloatingActionButton(
            heroTag: 'fab_calls',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Start a new call')),
              );
            },
            tooltip: 'New Call',
            child: const Icon(Icons.add_call),
          ),
        );
      case 4: // Profile tab
      default:
        return null;
    }
  }
}
