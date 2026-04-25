import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/settings/view/settings_view.dart';
import '../helpers/test_app.dart';

void main() {
  group('SettingsView', () {
    testWidgets('renders settings title', (tester) async {
      await tester.pumpWidget(buildTestApp(const SettingsView()));
      await tester.pump(const Duration(milliseconds: 100));

      // "Settings" appears as both AppBar title and section header — both acceptable.
      expect(find.textContaining('Settings'), findsAtLeastNWidgets(1));
    });

    testWidgets('renders link account section for anonymous user', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(const SettingsView()));
      await tester.pump(const Duration(milliseconds: 100));

      // "Link Account" appears as both section header and ListTile title.
      // Individual provider buttons (Link with Apple/Google) live inside the
      // bottom sheet that opens on tap, so they are not rendered upfront.
      expect(find.text('Link Account'), findsAtLeastNWidgets(1));
      // Logout hidden for anonymous users
      expect(find.text('Log Out'), findsNothing);
    });

    testWidgets('renders in Korean', (tester) async {
      await tester.pumpWidget(buildTestApp(const SettingsView(), locale: 'ko'));
      await tester.pump(const Duration(milliseconds: 100));

      // "설정" appears as both AppBar title and section header.
      expect(find.textContaining('설정'), findsAtLeastNWidgets(1));
      expect(find.text('계정 연결'), findsAtLeastNWidgets(1));
    });
  });
}
