import 'package:flutter/material.dart';

/// A list tile with leading icon/avatar, title, subtitle, and trailing widget.
class AppListTile extends StatelessWidget {
  const AppListTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.dense = false,
    this.padding,
    this.contentPadding,
    super.key,
  });

  /// Title text.
  final String title;

  /// Optional subtitle text.
  final String? subtitle;

  /// Leading widget (icon, avatar, etc.).
  final Widget? leading;

  /// Trailing widget (arrow, badge, etc.).
  final Widget? trailing;

  /// Called when the tile is tapped.
  final VoidCallback? onTap;

  /// Whether this tile is dense.
  final bool dense;

  /// Optional outer padding around the list tile.
  final EdgeInsetsGeometry? padding;

  /// Optional content padding inside the list tile.
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    Widget tile = ListTile(
      leading: leading,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing:
          trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
      dense: dense,
      contentPadding: contentPadding,
    );

    if (padding != null) {
      tile = Padding(padding: padding!, child: tile);
    }

    return tile;
  }
}
