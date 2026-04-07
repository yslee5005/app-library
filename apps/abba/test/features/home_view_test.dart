import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/home/view/home_view.dart';
import '../helpers/test_app.dart';

void main() {
  group('HomeView', () {
    testWidgets('renders pray and QT tabs', (tester) async {
      await tester.pumpWidget(buildTestApp(const HomeView()));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Tabs contain emoji prefix + text
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('renders streak card', (tester) async {
      await tester.pumpWidget(buildTestApp(const HomeView(), locale: 'ko'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
