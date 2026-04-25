import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// A single stat shown in [ProfileHeader].
class ProfileStat {
  const ProfileStat({required this.label, required this.count});

  /// Stat label (e.g. "Followers").
  final String label;

  /// Stat count.
  final int count;
}

/// Circular avatar + display name + bio + stats row.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.displayName,
    this.avatarUrl,
    this.bio,
    this.stats = const [],
    this.avatarRadius = 48.0,
    this.onAvatarTap,
    this.spacing,
    super.key,
  });

  /// User display name.
  final String displayName;

  /// Avatar image URL (network). Falls back to initials.
  final String? avatarUrl;

  /// Short bio text.
  final String? bio;

  /// Stats to show (e.g. followers, following, posts).
  final List<ProfileStat> stats;

  /// Radius of the avatar circle.
  final double avatarRadius;

  /// Called when the avatar is tapped.
  final VoidCallback? onAvatarTap;

  /// Optional spacing between profile sections. Defaults to [AppSpacing.md].
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Avatar
        GestureDetector(
          onTap: onAvatarTap,
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child:
                avatarUrl == null
                    ? Text(
                      displayName.isNotEmpty
                          ? displayName[0].toUpperCase()
                          : '?',
                      style: theme.textTheme.headlineLarge,
                    )
                    : null,
          ),
        ),
        SizedBox(height: spacing ?? AppSpacing.md),

        // Name
        Text(displayName, style: theme.textTheme.titleLarge),

        // Bio
        if (bio != null && bio!.isNotEmpty) ...[
          SizedBox(height: spacing != null ? spacing! / 2 : AppSpacing.xs),
          Text(
            bio!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],

        // Stats row
        if (stats.isNotEmpty) ...[
          SizedBox(height: spacing ?? AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                stats.map((stat) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Column(
                      children: [
                        Text(
                          stat.count.toString(),
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          stat.label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ],
    );
  }
}
