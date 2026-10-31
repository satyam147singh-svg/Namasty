import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../domain/navigation_item.dart';

/// Floating pill-shaped bottom navigation bar for Namasty - Messenger
/// 100% Original Design: 24px rounded corners, soft shadow, sky blue pill indicator, unread badges
class NamastyBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final int unreadChats;
  final int unreadGroups;
  final int missedCalls;

  const NamastyBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    this.unreadChats = 2,
    this.unreadGroups = 3,
    this.missedCalls = 1,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tabs = [
      _TabConfig(
        option: NavTabOption.chats,
        label: 'Chats',
        icon: Icons.chat_bubble_outline_rounded,
        selectedIcon: Icons.chat_bubble_rounded,
        badgeCount: unreadChats,
      ),
      _TabConfig(
        option: NavTabOption.status,
        label: 'Status',
        icon: Icons.donut_large_rounded,
        selectedIcon: Icons.donut_large_rounded,
        badgeCount: 0,
      ),
      _TabConfig(
        option: NavTabOption.groups,
        label: 'Groups',
        icon: Icons.groups_outlined,
        selectedIcon: Icons.groups_rounded,
        badgeCount: unreadGroups,
      ),
      _TabConfig(
        option: NavTabOption.calls,
        label: 'Calls',
        icon: Icons.call_outlined,
        selectedIcon: Icons.call_rounded,
        badgeCount: missedCalls,
      ),
      _TabConfig(
        option: NavTabOption.profile,
        label: 'Profile',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        badgeCount: 0,
      ),
    ];

    return SafeArea(
      top: false,
      child: Container(
        height: 68,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? colors.surface : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colors.cardBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.35)
                  : colors.primaryDark.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(tabs.length, (index) {
            final tab = tabs[index];
            final isSelected = currentIndex == index;

            return _buildTabItem(
              context: context,
              colors: colors,
              isDark: isDark,
              tab: tab,
              isSelected: isSelected,
              onTap: () => onTabSelected(index),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required NamastyColors colors,
    required bool isDark,
    required _TabConfig tab,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // Requirements: Active tab shows light blue pill/highlight (#D6EFFB)
    // with icon + label in dark navy (#12324A). Inactive tabs show only muted icon (#6B8BA4).
    final activePillColor = isDark ? const Color(0xFF1B374C) : const Color(0xFFD6EFFB);
    final activeTextColor = isDark ? const Color(0xFFE6F1FA) : const Color(0xFF12324A);
    const inactiveIconColor = Color(0xFF6B8BA4);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? activePillColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? tab.selectedIcon : tab.icon,
                  color: isSelected ? activeTextColor : inactiveIconColor,
                  size: 24,
                ),
                if (tab.badgeCount > 0 && !isSelected)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? colors.surface : Colors.white,
                          width: 1.5,
                        ),
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        tab.badgeCount > 99 ? '99+' : '${tab.badgeCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1.0 : 0.0,
                child: Text(
                  tab.label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: activeTextColor,
                  ),
                ),
              ),
              if (tab.badgeCount > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${tab.badgeCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _TabConfig {
  final NavTabOption option;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int badgeCount;

  const _TabConfig({
    required this.option,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.badgeCount = 0,
  });
}
