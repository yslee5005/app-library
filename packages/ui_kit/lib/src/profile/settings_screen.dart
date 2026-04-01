import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// The type of a settings item.
enum SettingsItemType { toggle, navigation, select }

/// A single item in a [SettingsSection].
class SettingsItem {
  const SettingsItem({
    required this.title,
    required this.type,
    this.subtitle,
    this.icon,
    this.value,
    this.onTap,
    this.onChanged,
    this.options,
  });

  /// Item title.
  final String title;

  /// Optional subtitle.
  final String? subtitle;

  /// Leading icon.
  final IconData? icon;

  /// Item type.
  final SettingsItemType type;

  /// Current value. For [SettingsItemType.toggle] this is a [bool].
  /// For [SettingsItemType.select] this is the selected option string.
  final Object? value;

  /// Called when a navigation item is tapped.
  final VoidCallback? onTap;

  /// Called when a toggle or select value changes.
  final ValueChanged<Object>? onChanged;

  /// Options for [SettingsItemType.select].
  final List<String>? options;
}

/// A titled group of [SettingsItem]s.
class SettingsSection {
  const SettingsSection({required this.title, required this.items});

  /// Section title.
  final String title;

  /// Items in this section.
  final List<SettingsItem> items;
}

/// A full settings screen with sections and items.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.sections,
    this.padding,
    super.key,
  });

  /// Settings sections.
  final List<SettingsSection> sections;

  /// Optional padding around the list.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: padding ?? const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: sections.length,
      itemBuilder: (context, sectionIndex) {
        final section = sections[sectionIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xs,
              ),
              child: Text(
                section.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            ...section.items.map((item) => _buildItem(context, item)),
            if (sectionIndex < sections.length - 1)
              const Divider(height: AppSpacing.md),
          ],
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, SettingsItem item) {
    switch (item.type) {
      case SettingsItemType.toggle:
        return SwitchListTile(
          title: Text(item.title),
          subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
          secondary: item.icon != null ? Icon(item.icon) : null,
          value: item.value as bool? ?? false,
          onChanged: (value) => item.onChanged?.call(value),
        );

      case SettingsItemType.navigation:
        return ListTile(
          leading: item.icon != null ? Icon(item.icon) : null,
          title: Text(item.title),
          subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
          trailing: const Icon(Icons.chevron_right),
          onTap: item.onTap,
        );

      case SettingsItemType.select:
        return ListTile(
          leading: item.icon != null ? Icon(item.icon) : null,
          title: Text(item.title),
          subtitle: Text(item.value as String? ?? ''),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            if (item.options != null && item.options!.isNotEmpty) {
              _showSelectDialog(context, item);
            }
          },
        );
    }
  }

  void _showSelectDialog(BuildContext context, SettingsItem item) {
    showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(item.title),
        children: item.options!.map((option) {
          return SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop(option);
              item.onChanged?.call(option);
            },
            child: Text(option),
          );
        }).toList(),
      ),
    );
  }
}
