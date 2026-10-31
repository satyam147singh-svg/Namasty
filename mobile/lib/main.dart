import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/namasty_theme.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/calls/presentation/screens/calls_screen.dart';
import 'features/chat/presentation/screens/chat_list_screen.dart';
import 'features/groups/presentation/screens/groups_screen.dart';
import 'features/navigation/domain/navigation_item.dart';
import 'features/navigation/presentation/widgets/namasty_shell.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/status/presentation/screens/status_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: NamastyApp()));
}

class NamastyApp extends StatelessWidget {
  const NamastyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Namasty - Messenger',
      debugShowCheckedModeBanner: false,
      theme: NamastyTheme.lightTheme,
      darkTheme: NamastyTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}

/// The main Shell wrapper connecting the animated Sidebar to all 5 screens
class NamastyMainShellScreen extends StatelessWidget {
  const NamastyMainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NamastyShell(
      screenBuilder: (currentOption, openSidebar) {
        switch (currentOption) {
          case SidebarOption.chats:
            return ChatListScreen(onOpenSidebar: openSidebar);
          case SidebarOption.status:
            return StatusScreen(onOpenSidebar: openSidebar);
          case SidebarOption.groups:
            return GroupsScreen(onOpenSidebar: openSidebar);
          case SidebarOption.calls:
            return CallsScreen(onOpenSidebar: openSidebar);
          case SidebarOption.profile:
            return ProfileScreen(onOpenSidebar: openSidebar);
        }
      },
      fabBuilder: (currentOption) {
        switch (currentOption) {
          case SidebarOption.chats:
            return FloatingActionButton(
              onPressed: () {
                // New chat dialog or action
              },
              tooltip: 'New Chat',
              child: const Icon(Icons.chat_bubble_rounded),
            );
          case SidebarOption.status:
            return FloatingActionButton(
              onPressed: () {},
              tooltip: 'Add Status',
              child: const Icon(Icons.camera_alt_rounded),
            );
          case SidebarOption.groups:
            return FloatingActionButton(
              onPressed: () {},
              tooltip: 'New Group',
              child: const Icon(Icons.group_add_rounded),
            );
          case SidebarOption.calls:
            return FloatingActionButton(
              onPressed: () {},
              tooltip: 'New Call',
              child: const Icon(Icons.add_call),
            );
          case SidebarOption.profile:
            return null;
        }
      },
    );
  }
}
