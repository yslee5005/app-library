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

    testWidgets('renders link account section for anonymous user', (tester) async {
      await tester.pumpWidget(buildTestApp(const SettingsView()));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Link Account'), findsOneWidget);
      expect(find.text('Link with Apple'), findsOneWidget);
      expect(find.text('Link with Google'), findsOneWidget);
      // Logout hidden for anonymous users
      expect(find.text('Log Out'), findsNothing);
    });

    testWidgets('renders in Korean', (tester) async {
      await tester.pumpWidget(buildTestApp(const SettingsView(), locale: 'ko'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('설정'), findsOneWidget);
      expect(find.text('계정 연결'), findsOneWidget);
    });
  });
}
