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

/// The main Shell wrapper hosting the 5 bottom navigation tabs
class NamastyMainShellScreen extends StatelessWidget {
  const NamastyMainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NamastyShell();
  }
}
