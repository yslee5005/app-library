import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:abba/features/dashboard/view/dashboard_view.dart';
import 'package:abba/providers/providers.dart';
import '../helpers/test_app.dart';

void main() {
  group('DashboardView', () {
    testWidgets('renders card titles when result loaded', (tester) async {
      // Use a larger surface to avoid overflow in test
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestApp(
          const DashboardView(),
          overrides: [
            prayerResultProvider.overrideWith(
              (ref) => AsyncValue.data(testPrayerResult),
            ),
          ],
        ),
      );
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.text("Today's Scripture"), findsOneWidget);
      expect(find.text('Bible Story'), findsOneWidget);
      expect(find.text('My Testimony'), findsOneWidget);
    });

    testWidgets('shows loading when result is loading', (tester) async {
      await tester.pumpWidget(buildTestApp(const DashboardView()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
