import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// A single item in the drawer menu.
class DrawerMenuItem {
  const DrawerMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  /// Leading icon.
  final IconData icon;

  /// Menu label.
  final String label;

  /// Called when the item is tapped.
  final VoidCallback onTap;
}

/// Side drawer with a header (avatar + name) and a list of [DrawerMenuItem].
class AppDrawerMenu extends StatelessWidget {
  const AppDrawerMenu({
    required this.items,
    this.avatarUrl,
    this.displayName,
    this.email,
    this.headerDecoration,
    this.onHeaderTap,
    super.key,
  });

  /// Menu items.
  final List<DrawerMenuItem> items;

  /// Avatar image URL (network). Falls back to a person icon.
  final String? avatarUrl;

  /// User display name shown in the header.
  final String? displayName;

  /// User email shown in the header.
  final String? email;

  /// Optional decoration for the header area.
  final BoxDecoration? headerDecoration;

  /// Called when the header is tapped.
  final VoidCallback? onHeaderTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: headerDecoration ??
                BoxDecoration(color: colorScheme.primaryContainer),
            accountName: Text(
              displayName ?? '',
              style: TextStyle(color: colorScheme.onPrimaryContainer),
            ),
            accountEmail: email != null
                ? Text(
                    email!,
                    style: TextStyle(color: colorScheme.onPrimaryContainer),
                  )
                : null,
            currentAccountPicture: GestureDetector(
              onTap: onHeaderTap,
              child: CircleAvatar(
                backgroundImage:
                    avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                child: avatarUrl == null ? const Icon(Icons.person) : null,
              ),
            ),
            onDetailsPressed: onHeaderTap,
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.xs),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.label),
                  onTap: () {
                    Navigator.of(context).pop();
                    item.onTap();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
