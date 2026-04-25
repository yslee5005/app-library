/// Responsive breakpoints for consistent layout decisions.
///
/// Based on Material 3 window size classes:
/// https://m3.material.io/foundations/layout/applying-layout/window-size-classes
///
/// Usage:
/// ```dart
/// final size = ScreenSize.fromWidth(MediaQuery.sizeOf(context).width);
///
/// switch (size) {
///   case ScreenSize.compact:  // phone portrait
///   case ScreenSize.medium:   // phone landscape, small tablet
///   case ScreenSize.expanded: // tablet, desktop
///   case ScreenSize.large:    // large tablet, desktop
/// }
/// ```
enum ScreenSize {
  /// < 600dp — phone portrait.
  compact(0),

  /// 600–839dp — phone landscape, small tablet portrait.
  medium(600),

  /// 840–1199dp — tablet, small desktop.
  expanded(840),

  /// >= 1200dp — large tablet landscape, desktop.
  large(1200);

  const ScreenSize(this.minWidth);

  /// Determine [ScreenSize] from a width in logical pixels.
  factory ScreenSize.fromWidth(double width) {
    if (width >= large.minWidth) return large;
    if (width >= expanded.minWidth) return expanded;
    if (width >= medium.minWidth) return medium;
    return compact;
  }

  /// Minimum width in logical pixels for this size class.
  final double minWidth;

  /// Number of grid columns recommended for this size.
  int get columns => switch (this) {
    compact => 4,
    medium => 8,
    expanded => 12,
    large => 12,
  };

  /// Recommended content max width (0 = fill).
  double get maxContentWidth => switch (this) {
    compact => double.infinity,
    medium => double.infinity,
    expanded => 840,
    large => 1040,
  };

  /// Recommended horizontal padding.
  double get horizontalPadding => switch (this) {
    compact => 16,
    medium => 24,
    expanded => 24,
    large => 32,
  };
}
