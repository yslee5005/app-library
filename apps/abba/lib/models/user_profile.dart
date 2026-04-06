enum SubscriptionStatus { free, premium, trial }

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final int totalPrayers;
  final int currentStreak;
  final int bestStreak;
  final SubscriptionStatus subscription;
  final String locale;
  final String voicePreference;
  final String? reminderTime;
  final bool darkMode;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.totalPrayers = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.subscription = SubscriptionStatus.free,
    this.locale = 'en',
    this.voicePreference = 'warm',
    this.reminderTime,
    this.darkMode = false,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      totalPrayers: json['total_prayers'] as int? ?? 0,
      currentStreak: json['current_streak'] as int? ?? 0,
      bestStreak: json['best_streak'] as int? ?? 0,
      subscription: SubscriptionStatus.values.firstWhere(
        (e) => e.name == (json['subscription'] as String? ?? 'free'),
        orElse: () => SubscriptionStatus.free,
      ),
      locale: json['locale'] as String? ?? 'en',
      voicePreference: json['voice_preference'] as String? ?? 'warm',
      reminderTime: json['reminder_time'] as String?,
      darkMode: json['dark_mode'] as bool? ?? false,
    );
  }

  UserProfile copyWith({
    String? locale,
    String? voicePreference,
    bool? darkMode,
    String? reminderTime,
  }) {
    return UserProfile(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      totalPrayers: totalPrayers,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      subscription: subscription,
      locale: locale ?? this.locale,
      voicePreference: voicePreference ?? this.voicePreference,
      reminderTime: reminderTime ?? this.reminderTime,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}
