import 'package:flutter/material.dart';

/// ListTile with a dark mode toggle switch.
class ThemeSwitchTile extends StatelessWidget {
  const ThemeSwitchTile({
    required this.isDarkMode,
    required this.onChanged,
    this.title = 'Dark Mode',
    this.icon,
    super.key,
  });

  /// Whether dark mode is currently enabled.
  final bool isDarkMode;

  /// Called when the switch value changes.
  final ValueChanged<bool> onChanged;

  /// Tile title.
  final String title;

  /// Optional leading icon. Defaults to a brightness icon.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      secondary: Icon(icon ?? (isDarkMode ? Icons.dark_mode : Icons.light_mode)),
      value: isDarkMode,
      onChanged: onChanged,
    );
  }
}
