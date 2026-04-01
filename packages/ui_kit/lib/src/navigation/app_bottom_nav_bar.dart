import 'package:flutter/material.dart';

/// A single item in [AppBottomNavBar].
class AppBottomNavItem {
  const AppBottomNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.badgeCount,
  });

  /// Default icon.
  final IconData icon;

  /// Icon when selected.
  final IconData? activeIcon;

  /// Text label.
  final String label;

  /// Optional badge count. Shown as a badge on the icon when > 0.
  final int? badgeCount;
}

/// Custom bottom navigation bar with icon, label, and optional badge count.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  /// Navigation items.
  final List<AppBottomNavItem> items;

  /// Currently selected index.
  final int currentIndex;

  /// Called when an item is tapped.
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: items.map((item) {
        Widget icon = Icon(item.icon);
        Widget activeIcon = Icon(item.activeIcon ?? item.icon);

        if (item.badgeCount != null && item.badgeCount! > 0) {
          icon = Badge.count(
            count: item.badgeCount!,
            child: icon,
          );
          activeIcon = Badge.count(
            count: item.badgeCount!,
            child: activeIcon,
          );
        }

        return NavigationDestination(
          icon: icon,
          selectedIcon: activeIcon,
          label: item.label,
        );
      }).toList(),
    );
  }
}
