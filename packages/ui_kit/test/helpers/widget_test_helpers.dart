import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Standard test screen sizes matching [ScreenSize] breakpoints.
abstract final class TestScreenSizes {
  /// Compact — small phone portrait (320 x 568).
  static const compact = Size(320, 568);

  /// Medium phone — typical phone portrait (375 x 812).
  static const phone = Size(375, 812);

  /// Medium — phone landscape / small tablet (768 x 1024).
  static const medium = Size(768, 1024);

  /// Expanded — tablet portrait (1024 x 1366).
  static const expanded = Size(1024, 1366);
}

/// Wraps [child] in a [MaterialApp] + [Scaffold] for widget testing.
///
/// Optionally set [screenSize] to test at specific dimensions.
Widget buildTestApp(Widget child, {Size? screenSize, ThemeData? theme}) {
  Widget app = MaterialApp(theme: theme, home: Scaffold(body: child));

  if (screenSize != null) {
    app = MediaQuery(data: MediaQueryData(size: screenSize), child: app);
  }

  return app;
}

/// Tests that [widget] does not cause a layout overflow at [size].
///
/// Usage:
/// ```dart
/// testOverflow(
///   'MyWidget does not overflow on compact',
///   widget: const MyWidget(),
///   size: TestScreenSizes.compact,
/// );
/// ```
void testOverflow(
  String description, {
  required Widget widget,
  required Size size,
}) {
  testWidgets(description, (tester) async {
    // Capture Flutter errors during this test.
    final errors = <FlutterErrorDetails>[];
    final originalHandler = FlutterError.onError;
    FlutterError.onError = (details) => errors.add(details);

    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildTestApp(widget, screenSize: size));
    await tester.pumpAndSettle();

    // Restore original error handler.
    FlutterError.onError = originalHandler;

    // Check for overflow errors.
    final overflowErrors = errors.where(
      (e) => e.toString().contains('overflowed'),
    );

    expect(
      overflowErrors,
      isEmpty,
      reason: 'Widget should not overflow at ${size.width}x${size.height}',
    );
  });
}

/// Tests that [widget] renders without errors at multiple screen sizes.
///
/// Usage:
/// ```dart
/// testResponsive(
///   'MyWidget',
///   widget: const MyWidget(),
/// );
/// ```
void testResponsive(
  String widgetName, {
  required Widget widget,
  List<Size>? sizes,
}) {
  final testSizes =
      sizes ??
      [TestScreenSizes.compact, TestScreenSizes.phone, TestScreenSizes.medium];

  group('$widgetName responsive', () {
    for (final size in testSizes) {
      testOverflow(
        'no overflow at ${size.width.toInt()}x${size.height.toInt()}',
        widget: widget,
        size: size,
      );
    }
  });
}
