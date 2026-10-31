import 'package:flutter/material.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../domain/navigation_item.dart';
import 'namasty_sidebar_drawer.dart';

class NamastyShell extends StatefulWidget {
  final Widget Function(SidebarOption currentOption, VoidCallback openSidebar) screenBuilder;
  final Widget? Function(SidebarOption currentOption)? fabBuilder;

  const NamastyShell({
    super.key,
    required this.screenBuilder,
    this.fabBuilder,
  });

  @override
  State<NamastyShell> createState() => _NamastyShellState();
}

class _NamastyShellState extends State<NamastyShell> with SingleTickerProviderStateMixin {
  SidebarOption _currentOption = SidebarOption.chats;
  late AnimationController _sidebarController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _sidebarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _slideAnimation = CurvedAnimation(
      parent: _sidebarController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    if (_sidebarController.isCompleted) {
      _sidebarController.reverse();
    } else {
      _sidebarController.forward();
    }
  }

  void _closeSidebar() {
    if (_sidebarController.isCompleted || _sidebarController.isAnimating) {
      _sidebarController.reverse();
    }
  }

  void _onSelectOption(SidebarOption option) {
    setState(() {
      _currentOption = option;
    });
    _closeSidebar();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 800;

    if (isTablet) {
      // Tablet / Desktop layout with permanent side rail
      return Scaffold(
        body: Row(
          children: [
            NamastySidebarDrawer(
              currentOption: _currentOption,
              onSelectOption: _onSelectOption,
              isRailMode: true,
            ),
            Expanded(
              child: widget.screenBuilder(_currentOption, _toggleSidebar),
            ),
          ],
        ),
        floatingActionButton: widget.fabBuilder?.call(_currentOption),
      );
    }

    // Mobile layout with animated slide-in drawer
    return Scaffold(
      body: Stack(
        children: [
          // 1. Full width Active Screen
          widget.screenBuilder(_currentOption, _toggleSidebar),

          // 2. Dimmed barrier overlay
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              if (_slideAnimation.value == 0) return const SizedBox.shrink();
              return Positioned.fill(
                child: GestureDetector(
                  onTap: _closeSidebar,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    color: Colors.black.withOpacity(_slideAnimation.value * 0.4),
                  ),
                ),
              );
            },
          ),

          // 3. Smooth animated Slide-In Sidebar Drawer
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              final offset = (_slideAnimation.value - 1.0) * 320;
              return Positioned(
                top: 0,
                bottom: 0,
                left: offset,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (details.primaryDelta != null && details.primaryDelta! < -8) {
                      _closeSidebar(); // Swipe left to close
                    }
                  },
                  child: NamastySidebarDrawer(
                    currentOption: _currentOption,
                    onSelectOption: _onSelectOption,
                    onClose: _closeSidebar,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: widget.fabBuilder?.call(_currentOption),
    );
  }
}
