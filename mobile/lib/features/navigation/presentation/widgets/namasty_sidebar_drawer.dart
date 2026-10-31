import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';
import '../../../../core/widgets/namasty_logo.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../domain/navigation_item.dart';

class NamastySidebarDrawer extends StatelessWidget {
  final SidebarOption currentOption;
  final Function(SidebarOption) onSelectOption;
  final VoidCallback? onClose;
  final String userName;
  final String userAbout;
  final String? userAvatarUrl;
  final int totalUnreadChats;
  final bool isRailMode;

  const NamastySidebarDrawer({
    super.key,
    required this.currentOption,
    required this.onSelectOption,
    this.onClose,
    this.userName = 'Aarav Sharma',
    this.userAbout = 'Namasty! Baat karo, dil se.',
    this.userAvatarUrl,
    this.totalUnreadChats = 2,
    this.isRailMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    if (isRailMode) {
      return _buildPermanentRail(context, colors);
    }

    return Container(
      width: 320,
      height: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: colors.primaryDark.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 1. Light Blue Gradient Header
            _buildHeader(context, colors),

            const SizedBox(height: 12),

            // 2. Primary Navigation Items (Order: Chats, Status, Groups, Calls, Profile)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                children: [
                  _buildNavItem(
                    context,
                    colors,
                    option: SidebarOption.chats,
                    label: 'Chats',
                    icon: Icons.chat_bubble_outline_rounded,
                    selectedIcon: Icons.chat_bubble_rounded,
                    badgeCount: totalUnreadChats,
                  ),
                  _buildNavItem(
                    context,
                    colors,
                    option: SidebarOption.status,
                    label: 'Status',
                    icon: Icons.donut_large_rounded,
                    selectedIcon: Icons.donut_large_rounded,
                  ),
                  _buildNavItem(
                    context,
                    colors,
                    option: SidebarOption.groups,
                    label: 'Groups',
                    icon: Icons.groups_outlined,
                    selectedIcon: Icons.groups_rounded,
                  ),
                  _buildNavItem(
                    context,
                    colors,
                    option: SidebarOption.calls,
                    label: 'Calls',
                    icon: Icons.call_outlined,
                    selectedIcon: Icons.call_rounded,
                  ),
                  _buildNavItem(
                    context,
                    colors,
                    option: SidebarOption.profile,
                    label: 'Profile',
                    icon: Icons.person_outline_rounded,
                    selectedIcon: Icons.person_rounded,
                  ),

                  const SizedBox(height: 16),
                  Divider(color: colors.divider, thickness: 1, indent: 8, endIndent: 8),
                  const SizedBox(height: 8),

                  // Bottom items: Settings, Help, Invite Friends, Logout
                  _buildActionItem(
                    context,
                    colors,
                    label: 'Settings',
                    icon: Icons.settings_outlined,
                    onTap: () {
                      onClose?.call();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                  _buildActionItem(
                    context,
                    colors,
                    label: 'Invite Friends',
                    icon: Icons.person_add_alt_1_outlined,
                    onTap: () {
                      onClose?.call();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invite Friends: Share Namasty with contacts!')),
                      );
                    },
                  ),
                  _buildActionItem(
                    context,
                    colors,
                    label: 'Help & FAQ',
                    icon: Icons.help_outline_rounded,
                    onTap: () {
                      onClose?.call();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Help & Support: support@namasty.app')),
                      );
                    },
                  ),
                  _buildActionItem(
                    context,
                    colors,
                    label: 'Logout',
                    icon: Icons.logout_rounded,
                    iconColor: Colors.redAccent,
                    onTap: () {
                      onClose?.call();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logout functionality')),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Footer version
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 4),
              child: Text(
                'Namasty v${AppConstants.appVersion}',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NamastyColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.sidebarHeaderStart, colors.sidebarHeaderEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primaryDark.withOpacity(0.18),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const NamastyLogo(size: 38, wordmarkSize: 20, isDarkBackground: true),
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                onPressed: onClose,
                tooltip: 'Close sidebar',
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              NamastyAvatar(
                imageUrl: userAvatarUrl,
                fallbackInitials: userName,
                size: 52,
                borderRadius: 16,
                isOnline: true,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userAbout,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    NamastyColors colors, {
    required SidebarOption option,
    required String label,
    required IconData icon,
    required IconData selectedIcon,
    int badgeCount = 0,
  }) {
    final isSelected = currentOption == option;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: () {
          onSelectOption(option);
          onClose?.call();
        },
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? colors.activePill : Colors.transparent, // Sky blue pill
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? colors.primaryDark : colors.inactiveIcon,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? colors.primaryDark : colors.textSecondary,
                  ),
                ),
              ),
              if (badgeCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    NamastyColors colors, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Icon(icon, color: iconColor ?? colors.textSecondary, size: 22),
        title: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colors.textPrimary,
          ),
        ),
        dense: true,
        onTap: onTap,
      ),
    );
  }

  // Tablet / Desktop Permanent Collapsible Rail
  Widget _buildPermanentRail(BuildContext context, NamastyColors colors) {
    return Container(
      width: 76,
      height: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(right: BorderSide(color: colors.cardBorder, width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const NamastyLogo(size: 34, showWordmark: false),
          const SizedBox(height: 32),
          _buildRailItem(context, colors, SidebarOption.chats, Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded),
          _buildRailItem(context, colors, SidebarOption.status, Icons.donut_large_rounded, Icons.donut_large_rounded),
          _buildRailItem(context, colors, SidebarOption.groups, Icons.groups_outlined, Icons.groups_rounded),
          _buildRailItem(context, colors, SidebarOption.calls, Icons.call_outlined, Icons.call_rounded),
          _buildRailItem(context, colors, SidebarOption.profile, Icons.person_outline_rounded, Icons.person_rounded),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: colors.textSecondary),
            onPressed: () {},
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRailItem(
    BuildContext context,
    NamastyColors colors,
    SidebarOption option,
    IconData icon,
    IconData selectedIcon,
  ) {
    final isSelected = currentOption == option;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? colors.activePill : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            isSelected ? selectedIcon : icon,
            color: isSelected ? colors.primaryDark : colors.textSecondary,
          ),
        ),
        onPressed: () => onSelectOption(option),
      ),
    );
  }
}
