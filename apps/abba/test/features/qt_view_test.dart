import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/qt/view/qt_view.dart';
import '../helpers/test_app.dart';

void main() {
  group('QtView', () {
    testWidgets('renders QT page', (tester) async {
      await tester.pumpWidget(buildTestApp(const QtView()));
      // Advance past all reveal timers (5 cards × 600ms + 400ms = ~3400ms)
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should render a Scaffold
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
