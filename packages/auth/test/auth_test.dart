import 'package:app_lib_auth/src/domain/auth_state.dart';
import 'package:app_lib_auth/src/domain/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfile', () {
    test('fromJson creates profile correctly', () {
      final json = {
        'id': 'user-123',
        'app_id': 'my_app',
        'email': 'test@example.com',
        'display_name': 'Test User',
        'avatar_url': 'https://example.com/avatar.png',
        'provider': 'google',
        'onboarding_completed': true,
        'created_at': '2026-01-01T00:00:00Z',
        'updated_at': '2026-01-02T00:00:00Z',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.id, 'user-123');
      expect(profile.appId, 'my_app');
      expect(profile.email, 'test@example.com');
      expect(profile.displayName, 'Test User');
      expect(profile.avatarUrl, 'https://example.com/avatar.png');
      expect(profile.provider, 'google');
      expect(profile.onboardingCompleted, isTrue);
      expect(profile.createdAt, DateTime.utc(2026, 1, 1));
      expect(profile.updatedAt, DateTime.utc(2026, 1, 2));
    });

    test('fromJson handles null optional fields', () {
      final json = {
        'id': 'user-456',
        'app_id': 'other_app',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.id, 'user-456');
      expect(profile.appId, 'other_app');
      expect(profile.email, isNull);
      expect(profile.displayName, isNull);
      expect(profile.avatarUrl, isNull);
      expect(profile.provider, isNull);
      expect(profile.onboardingCompleted, isFalse);
      expect(profile.createdAt, isNull);
      expect(profile.updatedAt, isNull);
    });

    test('toJson produces correct map', () {
      const profile = UserProfile(
        id: 'user-123',
        appId: 'my_app',
        email: 'test@example.com',
        displayName: 'Test User',
        provider: 'google',
      );

      final json = profile.toJson();

      expect(json['id'], 'user-123');
      expect(json['app_id'], 'my_app');
      expect(json['email'], 'test@example.com');
      expect(json['display_name'], 'Test User');
      expect(json['provider'], 'google');
      expect(json['onboarding_completed'], isFalse);
      // avatar_url is null, should not be in map
      expect(json.containsKey('avatar_url'), isFalse);
    });

    test('copyWith replaces fields', () {
      const original = UserProfile(
        id: 'user-123',
        appId: 'my_app',
        email: 'test@example.com',
        displayName: 'Old Name',
      );

      final updated = original.copyWith(
        displayName: 'New Name',
        onboardingCompleted: true,
      );

      expect(updated.id, 'user-123');
      expect(updated.appId, 'my_app');
      expect(updated.email, 'test@example.com');
      expect(updated.displayName, 'New Name');
      expect(updated.onboardingCompleted, isTrue);
    });

    test('equality based on id and appId', () {
      const a = UserProfile(
        id: 'user-123',
        appId: 'my_app',
        email: 'a@test.com',
      );
      const b = UserProfile(
        id: 'user-123',
        appId: 'my_app',
        email: 'b@test.com',
      );
      const c = UserProfile(
        id: 'user-123',
        appId: 'other_app',
        email: 'a@test.com',
      );

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a.hashCode, b.hashCode);
    });

    test('toString includes key fields', () {
      const profile = UserProfile(
        id: 'user-123',
        appId: 'my_app',
        email: 'test@example.com',
      );

      expect(
        profile.toString(),
        'UserProfile(id: user-123, appId: my_app, email: test@example.com)',
      );
    });
  });

  group('AuthState', () {
    test('Authenticated holds user profile', () {
      const profile = UserProfile(id: 'u1', appId: 'app1');
      const state = Authenticated(user: profile);

      expect(state.user.id, 'u1');
      expect(state, isA<AuthState>());
    });

    test('Unauthenticated is a valid state', () {
      const state = Unauthenticated();
      expect(state, isA<AuthState>());
    });

    test('AuthLoading is a valid state', () {
      const state = AuthLoading();
      expect(state, isA<AuthState>());
    });

    test('AuthError holds message and optional code', () {
      const state = AuthError(message: 'token expired', code: 'AUTH_EXPIRED');

      expect(state.message, 'token expired');
      expect(state.code, 'AUTH_EXPIRED');
    });

    test('exhaustive pattern matching', () {
      const AuthState state = Unauthenticated();
      final label = switch (state) {
        Authenticated() => 'authenticated',
        Unauthenticated() => 'unauthenticated',
        AuthLoading() => 'loading',
        AuthError() => 'error',
      };
      expect(label, 'unauthenticated');
    });
  });
}
