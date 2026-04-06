import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/settings/view/settings_view.dart';
import '../helpers/test_app.dart';

void main() {
  group('SettingsView', () {
    testWidgets('renders settings title', (tester) async {
      await tester.pumpWidget(buildTestApp(const SettingsView()));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('Settings'), findsOneWidget);
    });

    testWidgets('renders logout button', (tester) async {
      await tester.pumpWidget(buildTestApp(const SettingsView()));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Log Out'), findsOneWidget);
    });

    testWidgets('renders in Korean', (tester) async {
      await tester.pumpWidget(buildTestApp(const SettingsView(), locale: 'ko'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('설정'), findsOneWidget);
      expect(find.text('로그아웃'), findsOneWidget);
    });
  });
}
