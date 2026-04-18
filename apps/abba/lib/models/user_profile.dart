enum SubscriptionStatus { free, premium, trial }

/// Abba domain user profile — combines auth profile + app-specific settings.
///
/// In the database this is split into two tables:
/// - `profiles` (auth, managed by packages/auth)
/// - `abba_user_settings` (domain, managed by abba)
///
/// This model is the merged view used in the UI.
class UserProfile {
  final String id;
  final String displayName;
  final String email;
  final String? avatarUrl;
  final int totalPrayers;
  final int currentStreak;
  final int bestStreak;
  final SubscriptionStatus subscription;
  final String locale;
  final String? reminderTime;
  final bool darkMode;

  const UserProfile({
    required this.id,
    this.displayName = '',
    this.email = '',
    this.avatarUrl,
    this.totalPrayers = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.subscription = SubscriptionStatus.free,
    this.locale = 'en',
    this.reminderTime,
    this.darkMode = false,
  });

  /// Legacy getter for backward compatibility with views using `.name`.
  String get name => displayName;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      displayName: json['display_name'] as String? ?? json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      totalPrayers: json['total_prayers'] as int? ?? 0,
      currentStreak: json['current_streak'] as int? ?? 0,
      bestStreak: json['best_streak'] as int? ?? 0,
      subscription: SubscriptionStatus.values.firstWhere(
        (e) => e.name == (json['subscription'] as String? ?? 'free'),
        orElse: () => SubscriptionStatus.free,
      ),
      locale: json['locale'] as String? ?? 'en',
      reminderTime: json['reminder_time'] as String?,
      darkMode: json['dark_mode'] as bool? ?? false,
    );
  }

  /// Merge auth profile data with app settings data.
  factory UserProfile.fromProfileAndSettings(
    Map<String, dynamic> profile,
    Map<String, dynamic>? settings,
  ) {
    return UserProfile(
      id: profile['id'] as String,
      displayName: profile['display_name'] as String? ?? '',
      email: profile['email'] as String? ?? '',
      avatarUrl: profile['avatar_url'] as String?,
      totalPrayers: settings?['total_prayers'] as int? ?? 0,
      currentStreak: settings?['current_streak'] as int? ?? 0,
      bestStreak: settings?['best_streak'] as int? ?? 0,
      subscription: SubscriptionStatus.values.firstWhere(
        (e) => e.name == (settings?['subscription'] as String? ?? 'free'),
        orElse: () => SubscriptionStatus.free,
      ),
      locale: settings?['locale'] as String? ?? 'en',
      reminderTime: settings?['reminder_time'] as String?,
      darkMode: settings?['dark_mode'] as bool? ?? false,
    );
  }

  UserProfile copyWith({
    String? displayName,
    String? locale,
    bool? darkMode,
    String? reminderTime,
  }) {
    return UserProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      email: email,
      avatarUrl: avatarUrl,
      totalPrayers: totalPrayers,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      subscription: subscription,
      locale: locale ?? this.locale,
      reminderTime: reminderTime ?? this.reminderTime,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}
