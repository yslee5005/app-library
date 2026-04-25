/// A user profile scoped to a specific app.
///
/// Each app maintains separate profiles even if the same email is used
/// across multiple apps (multi-tenant isolation via app_id).
class UserProfile {
  const UserProfile({
    required this.id,
    required this.appId,
    this.email,
    this.displayName,
    this.avatarUrl,
    this.provider,
    this.onboardingCompleted = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Creates a [UserProfile] from a Supabase row.
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      appId: json['app_id'] as String,
      email: json['email'] as String?,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      provider: json['provider'] as String?,
      onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
    );
  }

  /// Supabase Auth user ID.
  final String id;

  /// App identifier for multi-tenant isolation.
  final String appId;

  /// User's email address.
  final String? email;

  /// Display name shown in the UI.
  final String? displayName;

  /// URL to the user's avatar image.
  final String? avatarUrl;

  /// Authentication provider ('google', 'apple', 'email').
  final String? provider;

  /// Whether the user has completed onboarding.
  final bool onboardingCompleted;

  /// When the profile was created.
  final DateTime? createdAt;

  /// When the profile was last updated.
  final DateTime? updatedAt;

  /// Converts to a JSON map for Supabase insertion.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'app_id': appId,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (provider != null) 'provider': provider,
      'onboarding_completed': onboardingCompleted,
    };
  }

  /// Creates a copy with the given fields replaced.
  UserProfile copyWith({
    String? id,
    String? appId,
    String? email,
    String? displayName,
    String? avatarUrl,
    String? provider,
    bool? onboardingCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      appId: appId ?? this.appId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      provider: provider ?? this.provider,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          appId == other.appId;

  @override
  int get hashCode => Object.hash(id, appId);

  @override
  String toString() => 'UserProfile(id: $id, appId: $appId, email: $email)';
}
