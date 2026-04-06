import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/welcome/view/welcome_view.dart';
import '../helpers/test_app.dart';

void main() {
  group('WelcomeView', () {
    testWidgets('renders logo and start button', (tester) async {
      await tester.pumpWidget(buildTestApp(const WelcomeView()));
      await tester.pumpAndSettle();

      // App name
      expect(find.text('Abba'), findsOneWidget);

      // Get Started button
      expect(find.text('Get Started'), findsOneWidget);

      // Logo emoji
      expect(find.text('🌿'), findsOneWidget);
    });

    testWidgets('renders in Korean locale', (tester) async {
      await tester.pumpWidget(buildTestApp(const WelcomeView(), locale: 'ko'));
      await tester.pumpAndSettle();

      expect(find.text('아바'), findsOneWidget);
      expect(find.text('시작하기'), findsOneWidget);
    });
  });
}
