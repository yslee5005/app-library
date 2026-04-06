import 'package:flutter_test/flutter_test.dart';

import 'package:abba/features/login/view/login_view.dart';
import '../helpers/test_app.dart';

void main() {
  group('LoginView', () {
    testWidgets('renders 3 login buttons', (tester) async {
      await tester.pumpWidget(buildTestApp(const LoginView()));
      await tester.pumpAndSettle();

      // Title
      expect(find.text('Welcome to Abba'), findsOneWidget);

      // 3 login buttons
      expect(find.text('Continue with Apple'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Email'), findsOneWidget);
    });

    testWidgets('renders in Korean', (tester) async {
      await tester.pumpWidget(buildTestApp(const LoginView(), locale: 'ko'));
      await tester.pumpAndSettle();

      expect(find.text('아바에 오신 것을 환영합니다'), findsOneWidget);
      expect(find.text('Apple로 계속하기'), findsOneWidget);
    });
  });
}
