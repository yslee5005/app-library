import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// A small badge overlay on any widget.
///
/// Shows a [count] number or a plain dot when [showDot] is true.
class BadgeWidget extends StatelessWidget {
  const BadgeWidget({
    required this.child,
    this.count,
    this.showDot = false,
    this.badgeColor,
    this.textColor,
    this.position = BadgePosition.topEnd,
    super.key,
  });

  /// The widget to overlay.
  final Widget child;

  /// Badge count. When 0 or null (and [showDot] is false) the badge is hidden.
  final int? count;

  /// When true shows a small dot instead of a count.
  final bool showDot;

  /// Badge background colour. Defaults to [ColorScheme.error].
  final Color? badgeColor;

  /// Badge text colour. Defaults to [ColorScheme.onError].
  final Color? textColor;

  /// Position of the badge relative to the child.
  final BadgePosition position;

  bool get _visible => showDot || (count != null && count! > 0);

  @override
  Widget build(BuildContext context) {
    if (!_visible) return child;

    final theme = Theme.of(context);
    final bg = badgeColor ?? theme.colorScheme.error;
    final fg = textColor ?? theme.colorScheme.onError;

    final (top, right, bottom, left) = switch (position) {
      BadgePosition.topEnd => (0.0, 0.0, null as double?, null as double?),
      BadgePosition.topStart => (0.0, null as double?, null as double?, 0.0),
      BadgePosition.bottomEnd =>
        (null as double?, 0.0, 0.0, null as double?),
      BadgePosition.bottomStart =>
        (null as double?, null as double?, 0.0, 0.0),
    };

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: top,
          right: right,
          bottom: bottom,
          left: left,
          child: Transform.translate(
            offset: const Offset(4, -4),
            child: showDot
                ? Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 2,
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      count! > 99 ? '99+' : count.toString(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: fg,
                        fontSize: 10,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

/// Position of the badge relative to the child.
enum BadgePosition { topEnd, topStart, bottomEnd, bottomStart }
