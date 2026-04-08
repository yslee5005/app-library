import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return NavigationBar(
      height: abbaTabBarHeight,
      backgroundColor: AbbaColors.white,
      indicatorColor: AbbaColors.sage.withValues(alpha: 0.2),
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: [
        NavigationDestination(
          icon: const Text('🌳', style: TextStyle(fontSize: 28)),
          selectedIcon: const Text('🌳', style: TextStyle(fontSize: 28)),
          label: l10n.tabHome,
        ),
        NavigationDestination(
          icon: const Text('📅', style: TextStyle(fontSize: 28)),
          selectedIcon: const Text('📅', style: TextStyle(fontSize: 28)),
          label: l10n.tabCalendar,
        ),
        NavigationDestination(
          icon: const Text('🌻', style: TextStyle(fontSize: 28)),
          selectedIcon: const Text('🌻', style: TextStyle(fontSize: 28)),
          label: l10n.tabCommunity,
        ),
        NavigationDestination(
          icon: const Text('⚙️', style: TextStyle(fontSize: 28)),
          selectedIcon: const Text('⚙️', style: TextStyle(fontSize: 28)),
          label: l10n.tabSettings,
        ),
      ],
    );
  }
}
