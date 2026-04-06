import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/qt/view/qt_view.dart';
import '../helpers/test_app.dart';

void main() {
  group('QtView', () {
    testWidgets('renders QT page title', (tester) async {
      await tester.pumpWidget(buildTestApp(const QtView()));
      // Multiple pumps for async data and localizations
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // The title might be in AppBar or as Text widget
      expect(find.textContaining('Morning Garden'), findsWidgets);
    });
  });
}
