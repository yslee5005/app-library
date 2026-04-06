import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/home/view/home_view.dart';
import '../helpers/test_app.dart';

void main() {
  group('HomeView', () {
    testWidgets('renders pray and QT buttons', (tester) async {
      await tester.pumpWidget(buildTestApp(const HomeView()));
      // Pump a few times for async providers
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Pray'), findsOneWidget);
      expect(find.text('Quiet Time'), findsOneWidget);
    });

    testWidgets('renders in Korean', (tester) async {
      await tester.pumpWidget(buildTestApp(const HomeView(), locale: 'ko'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('기도하기'), findsOneWidget);
      expect(find.text('QT하기'), findsOneWidget);
    });
  });
}
