/// Example: How to use widget test helpers for overflow testing.
///
/// Copy this pattern for every new screen/widget.
library;

import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'widget_test_helpers.dart';

void main() {
  // ── Pattern 1: Quick responsive test ──────────────────────────
  // Tests at compact, phone, and medium sizes automatically.
  testResponsive(
    'EmptyStateView',
    widget: const EmptyStateView(
      title: 'No items found',
      subtitle: 'Try adding something new',
      icon: Icons.inbox_outlined,
      actionLabel: 'Add Item',
    ),
  );

  // ── Pattern 2: Custom sizes ───────────────────────────────────
  testResponsive(
    'ErrorStateView',
    widget: const ErrorStateView(
      message: 'Something went wrong',
    ),
    sizes: [
      TestScreenSizes.compact,
      TestScreenSizes.medium,
      TestScreenSizes.expanded,
    ],
  );

  // ── Pattern 3: Individual overflow test ───────────────────────
  testOverflow(
    'EmptyStateView does not overflow with very long text',
    widget: const EmptyStateView(
      title: 'This is an extremely long title that should wrap '
          'properly without causing any overflow issues in the layout',
      subtitle: 'This subtitle is also quite long and should handle '
          'wrapping gracefully across different screen sizes',
    ),
    size: TestScreenSizes.compact,
  );

  // ── Pattern 4: Manual widget test with size control ───────────
  testWidgets('SkeletonLoader renders at compact size', (tester) async {
    await tester.binding.setSurfaceSize(TestScreenSizes.compact);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestApp(
        const SkeletonLoader(),
        screenSize: TestScreenSizes.compact,
      ),
    );

    expect(find.byType(SkeletonLoader), findsOneWidget);
  });
}
