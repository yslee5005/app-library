import 'package:flutter_test/flutter_test.dart';
import 'package:abba/models/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'user-1',
        'name': 'Grace',
        'email': 'grace@example.com',
        'avatar_url': null,
        'total_prayers': 45,
        'current_streak': 7,
        'best_streak': 21,
        'subscription': 'free',
        'locale': 'en',
        'voice_preference': 'warm',
        'reminder_time': '06:00',
        'dark_mode': false,
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.id, 'user-1');
      expect(profile.name, 'Grace');
      expect(profile.email, 'grace@example.com');
      expect(profile.avatarUrl, isNull);
      expect(profile.totalPrayers, 45);
      expect(profile.currentStreak, 7);
      expect(profile.bestStreak, 21);
      expect(profile.subscription, SubscriptionStatus.free);
      expect(profile.locale, 'en');
      expect(profile.voicePreference, 'warm');
      expect(profile.reminderTime, '06:00');
      expect(profile.darkMode, false);
    });

    test('fromJson handles premium subscription', () {
      final json = {
        'id': 'user-2',
        'name': 'John',
        'email': 'john@example.com',
        'subscription': 'premium',
      };

      final profile = UserProfile.fromJson(json);
      expect(profile.subscription, SubscriptionStatus.premium);
    });

    test('fromJson handles trial subscription', () {
      final json = {
        'id': 'user-3',
        'name': 'Test',
        'email': 'test@example.com',
        'subscription': 'trial',
      };

      final profile = UserProfile.fromJson(json);
      expect(profile.subscription, SubscriptionStatus.trial);
    });

    test('fromJson defaults to free for unknown subscription', () {
      final json = {
        'id': 'user-4',
        'name': 'Unknown',
        'email': 'unknown@example.com',
        'subscription': 'enterprise',
      };

      final profile = UserProfile.fromJson(json);
      expect(profile.subscription, SubscriptionStatus.free);
    });

    test('fromJson defaults for missing optional fields', () {
      final json = {
        'id': 'user-5',
        'name': 'Minimal',
        'email': 'min@example.com',
      };

      final profile = UserProfile.fromJson(json);

      expect(profile.totalPrayers, 0);
      expect(profile.currentStreak, 0);
      expect(profile.bestStreak, 0);
      expect(profile.subscription, SubscriptionStatus.free);
      expect(profile.locale, 'en');
      expect(profile.voicePreference, 'warm');
      expect(profile.reminderTime, isNull);
      expect(profile.darkMode, false);
    });

    test('copyWith creates modified copy', () {
      const profile = UserProfile(
        id: 'user-1',
        displayName: 'Grace',
        email: 'grace@example.com',
        locale: 'en',
      );

      final updated = profile.copyWith(locale: 'ko', darkMode: true);

      expect(updated.locale, 'ko');
      expect(updated.darkMode, true);
      expect(updated.name, 'Grace'); // unchanged
      expect(updated.email, 'grace@example.com'); // unchanged
    });
  });

  group('SubscriptionStatus', () {
    test('enum has correct values', () {
      expect(SubscriptionStatus.values, hasLength(3));
      expect(SubscriptionStatus.free.name, 'free');
      expect(SubscriptionStatus.premium.name, 'premium');
      expect(SubscriptionStatus.trial.name, 'trial');
    });
  });
}
