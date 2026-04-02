import 'package:flutter/material.dart';

/// A single tab entry for [AppTabLayout].
class AppTab {
  const AppTab({
    required this.label,
    required this.body,
    this.icon,
  });

  /// Tab label.
  final String label;

  /// Optional icon for the tab.
  final IconData? icon;

  /// Widget rendered as the body when this tab is active.
  final Widget body;
}

/// TabBar + TabBarView wrapper.
///
/// Takes a list of [AppTab] and renders a Material [TabBar] with a
/// corresponding [TabBarView].
class AppTabLayout extends StatelessWidget {
  const AppTabLayout({
    required this.tabs,
    this.isScrollable = false,
    this.initialIndex = 0,
    this.onTabChanged,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    super.key,
  });

  /// The list of tabs.
  final List<AppTab> tabs;

  /// Whether the tab bar is scrollable.
  final bool isScrollable;

  /// Initial tab index.
  final int initialIndex;

  /// Called when the selected tab changes.
  final ValueChanged<int>? onTabChanged;

  /// Optional color for the tab indicator.
  final Color? indicatorColor;

  /// Optional color for the selected tab label.
  final Color? labelColor;

  /// Optional color for unselected tab labels.
  final Color? unselectedLabelColor;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: initialIndex,
      child: Column(
        children: [
          TabBar(
            isScrollable: isScrollable,
            onTap: onTabChanged,
            indicatorColor: indicatorColor,
            labelColor: labelColor,
            unselectedLabelColor: unselectedLabelColor,
            tabs: tabs
                .map(
                  (tab) => Tab(
                    text: tab.label,
                    icon: tab.icon != null ? Icon(tab.icon) : null,
                  ),
                )
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: tabs.map((tab) => tab.body).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
