import 'package:flutter/material.dart';

enum SidebarOption {
  chats,
  status,
  groups,
  calls,
  profile,
}

class NavigationItemData {
  final SidebarOption option;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int unreadCount;

  const NavigationItemData({
    required this.option,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.unreadCount = 0,
  });
}
