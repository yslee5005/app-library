import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:abba/services/auth_service.dart';
import 'package:abba/services/mock_data.dart';
import 'package:abba/services/mock/mock_auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthService service;

  setUp(() {
    service = MockAuthService(MockDataService());
  });

  group('MockAuthService', () {
    test('signInWithGoogle returns profile', () async {
      final profile = await service.signInWithGoogle();

      expect(profile.id, isNotEmpty);
      expect(profile.name, isNotEmpty);
      expect(profile.email, isNotEmpty);
    });

    test('signInWithApple returns profile', () async {
      final profile = await service.signInWithApple();

      expect(profile.id, isNotEmpty);
      expect(profile.name, isNotEmpty);
    });

    test('signInWithEmail returns profile', () async {
      final profile = await service.signInWithEmail('test@test.com', 'pass');

      expect(profile.email, isNotEmpty);
    });

    test('authStateChanges emits authenticated after login', () async {
      // Subscribe before login to catch the emission
      final completer = Completer<AbbaAuthState>();
      final sub = service.authStateChanges.listen((state) {
        if (!completer.isCompleted) completer.complete(state);
      });

      await service.signInWithGoogle();

      final state = await completer.future.timeout(const Duration(seconds: 5));
      expect(state.status, AuthStatus.authenticated);
      expect(state.user, isNotNull);

      await sub.cancel();
    });

    test('signOut emits unauthenticated', () async {
      final states = <AbbaAuthState>[];
      final sub = service.authStateChanges.listen(states.add);

      await service.signInWithGoogle();
      await service.signOut();

      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(states.last.status, AuthStatus.unauthenticated);

      await sub.cancel();
    });

    test('getCurrentUser returns profile (mock always returns data)', () async {
      final user = await service.getCurrentUser();
      expect(user, isNotNull);
      expect(user!.name, isNotEmpty);
    });
  });

  group('AbbaAuthState', () {
    test('default state is unauthenticated', () {
      const state = AbbaAuthState();
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
      expect(state.error, isNull);
      expect(state.isAuthenticated, false);
    });

    test('copyWith creates modified state', () {
      const state = AbbaAuthState();
      final authed = state.copyWith(status: AuthStatus.authenticated);

      expect(authed.status, AuthStatus.authenticated);
      expect(authed.isAuthenticated, true);
    });

    test('copyWith with error', () {
      const state = AbbaAuthState();
      final errored = state.copyWith(error: 'Login failed');

      expect(errored.error, 'Login failed');
    });
  });
}
