import 'package:flutter/material.dart';

import '../theme/abba_theme.dart';

class AbbaTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AbbaTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: abbaTabBarHeight,
      backgroundColor: AbbaColors.white,
      indicatorColor: AbbaColors.sage.withValues(alpha: 0.2),
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Text('🌳', style: TextStyle(fontSize: 24)),
          selectedIcon: Text('🌳', style: TextStyle(fontSize: 24)),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Text('📅', style: TextStyle(fontSize: 24)),
          selectedIcon: Text('📅', style: TextStyle(fontSize: 24)),
          label: 'Calendar',
        ),
        NavigationDestination(
          icon: Text('🌻', style: TextStyle(fontSize: 24)),
          selectedIcon: Text('🌻', style: TextStyle(fontSize: 24)),
          label: 'Community',
        ),
        NavigationDestination(
          icon: Text('⚙️', style: TextStyle(fontSize: 24)),
          selectedIcon: Text('⚙️', style: TextStyle(fontSize: 24)),
          label: 'Settings',
        ),
      ],
    );
  }
}
