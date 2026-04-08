import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/dashboard/view/dashboard_view.dart';
import '../helpers/test_app.dart';

void main() {
  group('DashboardView', () {
    testWidgets('shows loading when result is loading', (tester) async {
      await tester.pumpWidget(buildTestApp(const DashboardView()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
