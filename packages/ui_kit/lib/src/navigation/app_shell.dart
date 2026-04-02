import 'package:flutter/material.dart';

import 'app_bottom_nav_bar.dart';

/// A tab entry for [AppShell].
class AppShellTab {
  const AppShellTab({
    required this.icon,
    required this.label,
    required this.body,
    this.activeIcon,
  });

  /// Icon shown in the bottom navigation bar.
  final IconData icon;

  /// Icon shown when the tab is selected.
  final IconData? activeIcon;

  /// Label displayed below the icon.
  final String label;

  /// Widget rendered as the page body when this tab is active.
  final Widget body;
}

/// Scaffold with configurable [BottomNavigationBar], optional [AppBar],
/// and optional [Drawer].
///
/// Takes a list of [AppShellTab] to define pages and navigation items.
class AppShell extends StatelessWidget {
  const AppShell({
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
    this.appBar,
    this.drawer,
    this.floatingActionButton,
    this.backgroundColor,
    super.key,
  });

  /// The list of tabs to display.
  final List<AppShellTab> tabs;

  /// The index of the currently selected tab.
  final int currentIndex;

  /// Called when a tab is tapped.
  final ValueChanged<int> onTabChanged;

  /// Optional app bar.
  final PreferredSizeWidget? appBar;

  /// Optional drawer.
  final Widget? drawer;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// Optional scaffold background color.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      backgroundColor: backgroundColor,
      body: IndexedStack(
        index: currentIndex,
        children: tabs.map((tab) => tab.body).toList(),
      ),
      bottomNavigationBar: AppBottomNavBar(
        items: tabs
            .map(
              (tab) => AppBottomNavItem(
                icon: tab.icon,
                activeIcon: tab.activeIcon,
                label: tab.label,
              ),
            )
            .toList(),
        currentIndex: currentIndex,
        onTap: onTabChanged,
      ),
    );
  }
}
