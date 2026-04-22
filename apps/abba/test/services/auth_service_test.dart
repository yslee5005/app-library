import 'package:app_lib_auth/auth.dart';
import 'package:app_lib_core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:abba/services/mock_data.dart';
import 'package:abba/services/mock/mock_auth_repository.dart';

import '../helpers/test_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository repo;

  setUp(() {
    // `MockDataService.fromData(...)` bypasses the `rootBundle` asset load so
    // `getUserProfile()` can succeed in `flutter_test` without the asset shim.
    final mockData = MockDataService.fromData(
      userProfile: TestFixtures.userProfile(),
    );
    repo = MockAuthRepository(mockData);
  });

  group('MockAuthRepository', () {
    test('signInWithGoogle returns profile', () async {
      final result = await repo.signInWithGoogle();

      expect(result, isA<Success<UserProfile>>());
      final profile = (result as Success<UserProfile>).value;
      expect(profile.id, isNotEmpty);
    });

    test('signInWithApple returns profile', () async {
      final result = await repo.signInWithApple();

      expect(result, isA<Success<UserProfile>>());
    });

    test('signInAnonymously sets isAnonymous true', () async {
      await repo.signInAnonymously();
      expect(repo.isAnonymous, true);
    });

    test('linkWithGoogle sets isAnonymous false', () async {
      await repo.signInAnonymously();
      expect(repo.isAnonymous, true);

      await repo.linkWithGoogle();
      expect(repo.isAnonymous, false);
    });

    test('onAuthStateChange emits after login', () async {
      final states = <AuthState>[];
      final sub = repo.onAuthStateChange().listen(states.add);

      await repo.signInWithGoogle();

      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(states, isNotEmpty);
      expect(states.last, isA<Authenticated>());

      await sub.cancel();
    });

    test('signOut emits Unauthenticated', () async {
      final states = <AuthState>[];
      final sub = repo.onAuthStateChange().listen(states.add);

      await repo.signInWithGoogle();
      await repo.signOut();

      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(states.last, isA<Unauthenticated>());

      await sub.cancel();
    });

    test('getCurrentUser returns profile', () async {
      final result = await repo.getCurrentUser();
      expect(result, isA<Success<UserProfile?>>());
    });
  });
}
