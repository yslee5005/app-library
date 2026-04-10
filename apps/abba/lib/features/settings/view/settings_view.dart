import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart' show Share;

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/user_profile.dart';
import '../../../providers/providers.dart';
import '../../../services/auth_service.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_card.dart';
import '../../../widgets/abba_snackbar.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  String _voicePreference = 'warm';
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        title: Text('${l10n.settingsTitle} ⚙️', style: AbbaTypography.h1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AbbaSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            _buildProfileSection(l10n, profileAsync),

            // Link account section (anonymous only)
            if (ref.read(authServiceProvider).isAnonymous)
              _buildLinkAccountCard(l10n),

            // My Prayer Garden button
            AbbaCard(
              margin: const EdgeInsets.only(bottom: AbbaSpacing.md),
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Text('\ud83c\udf3f', style: TextStyle(fontSize: 24)),
                title: Text(l10n.myPageTitle, style: AbbaTypography.body),
                trailing: const Icon(Icons.chevron_right, color: AbbaColors.muted),
                onTap: () => context.go('/settings/my-page'),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AbbaSpacing.md,
                  vertical: AbbaSpacing.xs,
                ),
              ),
            ),

            // Premium card
            _buildPremiumCard(l10n),
            const SizedBox(height: AbbaSpacing.md),

            // Groups section
            _buildGroupSection(l10n),
            const SizedBox(height: AbbaSpacing.md),

            // Settings list
            _buildNotificationSettings(l10n),
            const SizedBox(height: AbbaSpacing.md),

            AbbaCard(
              margin: const EdgeInsets.only(bottom: AbbaSpacing.md),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  // AI Voice
                  _SettingsTile(
                    icon: Icons.record_voice_over_outlined,
                    title: l10n.aiVoiceSetting,
                    trailing: DropdownButton<String>(
                      value: _voicePreference,
                      underline: const SizedBox.shrink(),
                      items: [
                        DropdownMenuItem(
                          value: 'warm',
                          child: Text(
                            l10n.voiceWarm,
                            style: AbbaTypography.bodySmall,
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'calm',
                          child: Text(
                            l10n.voiceCalm,
                            style: AbbaTypography.bodySmall,
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'strong',
                          child: Text(
                            l10n.voiceStrong,
                            style: AbbaTypography.bodySmall,
                          ),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => _voicePreference = v);
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  // Language
                  _SettingsTile(
                    icon: Icons.language,
                    title: l10n.languageSetting,
                    trailing: DropdownButton<String>(
                      value: locale,
                      underline: const SizedBox.shrink(),
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'ko', child: Text('한국어')),
                        DropdownMenuItem(value: 'ja', child: Text('日本語')),
                        DropdownMenuItem(value: 'es', child: Text('Español')),
                        DropdownMenuItem(value: 'zh', child: Text('中文')),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          ref.read(localeProvider.notifier).state = v;
                        }
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  // Dark mode
                  _SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: l10n.darkModeSetting,
                    trailing: Switch(
                      value: _darkMode,
                      onChanged: (v) => setState(() => _darkMode = v),
                      activeTrackColor: AbbaColors.sage,
                    ),
                  ),
                ],
              ),
            ),

            // Other settings
            AbbaCard(
              margin: const EdgeInsets.only(bottom: AbbaSpacing.md),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.help_outline,
                    title: l10n.helpCenter,
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.description_outlined,
                    title: l10n.termsOfService,
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: l10n.privacyPolicy,
                    onTap: () {},
                  ),
                  if (!ref.read(authServiceProvider).isAnonymous) ...[
                    const Divider(height: 1),
                    _SettingsTile(
                      icon: Icons.logout,
                      title: l10n.logout,
                      titleColor: AbbaColors.error,
                      onTap: () async {
                        await ref.read(authServiceProvider).signOut();
                        ref.read(authStateProvider.notifier).state =
                            const AbbaAuthState();
                        if (context.mounted) context.go('/welcome');
                      },
                    ),
                  ],
                ],
              ),
            ),

            // Version
            Center(
              child: Text(
                l10n.appVersion('1.0.0'),
                style: AbbaTypography.caption,
              ),
            ),
            const SizedBox(height: AbbaSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(
    AppLocalizations l10n,
    AsyncValue<UserProfile> profileAsync,
  ) {
    final isAnon = ref.read(authServiceProvider).isAnonymous;

    return profileAsync.when(
      data: (profile) => AbbaCard(
        margin: const EdgeInsets.only(bottom: AbbaSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AbbaColors.sage.withValues(alpha: 0.2),
              child: Text(
                isAnon
                    ? '\u{1F64F}'
                    : (profile.name.isNotEmpty
                        ? profile.name[0].toUpperCase()
                        : '?'),
                style: AbbaTypography.h1.copyWith(color: AbbaColors.sage),
              ),
            ),
            const SizedBox(width: AbbaSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAnon ? l10n.anonymousUser : profile.name,
                    style: AbbaTypography.h2,
                  ),
                  if (!isAnon)
                    Text(
                      profile.email,
                      style: AbbaTypography.bodySmall.copyWith(
                        color: AbbaColors.muted,
                      ),
                    ),
                  const SizedBox(height: AbbaSpacing.sm),
                  Row(
                    children: [
                      _StatBadge(
                        label: l10n.totalPrayers,
                        value: '${profile.totalPrayers}',
                      ),
                      const SizedBox(width: AbbaSpacing.md),
                      _StatBadge(
                        label: l10n.consecutiveDays,
                        value: '${profile.currentStreak}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
    );
  }

  Widget _buildLinkAccountCard(AppLocalizations l10n) {
    return AbbaCard(
      margin: const EdgeInsets.only(bottom: AbbaSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cloud_outlined, color: AbbaColors.sage),
              const SizedBox(width: AbbaSpacing.sm),
              Text(l10n.linkAccountTitle, style: AbbaTypography.h2),
            ],
          ),
          const SizedBox(height: AbbaSpacing.sm),
          Text(
            l10n.linkAccountDescription,
            style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.muted),
          ),
          const SizedBox(height: AbbaSpacing.md),
          // Apple link button
          SizedBox(
            width: double.infinity,
            height: abbaButtonHeight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.apple),
              label: Text(l10n.linkWithApple),
              onPressed: () => _linkAccount('apple'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AbbaColors.warmBrown,
                foregroundColor: AbbaColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AbbaRadius.lg),
                ),
              ),
            ),
          ),
          const SizedBox(height: AbbaSpacing.sm),
          // Google link button
          SizedBox(
            width: double.infinity,
            height: abbaButtonHeight,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.g_mobiledata),
              label: Text(l10n.linkWithGoogle),
              onPressed: () => _linkAccount('google'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AbbaColors.sage),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AbbaRadius.lg),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _linkAccount(String provider) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final auth = ref.read(authServiceProvider);
      if (provider == 'apple') {
        await auth.linkWithApple();
      } else {
        await auth.linkWithGoogle();
      }
      ref.invalidate(userProfileProvider);
      if (mounted) {
        setState(() {}); // Refresh to hide link card
        showAbbaSnackBar(context, message: l10n.linkAccountSuccess);
      }
    } catch (e) {
      if (mounted) {
        showAbbaSnackBar(context, message: l10n.errorGeneric);
      }
    }
  }

  Widget _buildPremiumCard(AppLocalizations l10n) {
    final premiumAsync = ref.watch(isPremiumProvider);
    final isPremium = premiumAsync.valueOrNull ?? false;

    return AbbaCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPremium) ...[
            // Active premium banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AbbaSpacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AbbaColors.softGold.withValues(alpha: 0.3),
                    AbbaColors.sage.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(AbbaRadius.md),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '✅ ${l10n.premiumActive}',
                    style: AbbaTypography.h2.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AbbaSpacing.md),
            SizedBox(
              width: double.infinity,
              height: abbaButtonHeight,
              child: OutlinedButton(
                onPressed: () async {
                  final service = ref.read(subscriptionServiceProvider);
                  await service.restorePurchases();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AbbaColors.sage),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AbbaRadius.lg),
                  ),
                ),
                child: Text(
                  l10n.comingSoon, // "Manage Subscription"
                  style: AbbaTypography.body.copyWith(color: AbbaColors.sage),
                ),
              ),
            ),
          ] else ...[
            // Promo banner (auto-hidden after promo end date)
            if (_isPromoActive) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AbbaSpacing.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AbbaColors.softGold.withValues(alpha: 0.3),
                      AbbaColors.softPink.withValues(alpha: 0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AbbaRadius.md),
                ),
                child: Column(
                  children: [
                    Text(
                      '🌸 ${l10n.promoBanner}',
                      style: AbbaTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AbbaSpacing.xs),
                    Text(
                      l10n.promoEndsOn(
                        '${_promoEndDate.year}-${_promoEndDate.month.toString().padLeft(2, '0')}-${_promoEndDate.day.toString().padLeft(2, '0')}',
                      ),
                      style: AbbaTypography.caption,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AbbaSpacing.md),
            ],
            // Price comparison
            Row(
              children: [
                Expanded(
                  child: _PlanColumn(
                    title: l10n.freePlan,
                    price: '\$0',
                    features: [l10n.planOncePerDay, '📜', '📖', '✍️'],
                    isActive: true,
                  ),
                ),
                const SizedBox(width: AbbaSpacing.md),
                Expanded(
                  child: _PlanColumn(
                    title: l10n.premiumPlan,
                    price: l10n.monthlyPrice,
                    features: [
                      l10n.planUnlimited,
                      '📜📖✍️',
                      '💬 AI',
                      '🔊 TTS',
                      '🔤',
                    ],
                    isActive: false,
                    isPremium: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AbbaSpacing.sm),
            Center(
              child: Text(
                '${l10n.yearlyPrice} (${l10n.yearlySave})',
                style: AbbaTypography.bodySmall.copyWith(
                  color: AbbaColors.muted,
                ),
              ),
            ),
            const SizedBox(height: AbbaSpacing.md),
            // Monthly CTA
            SizedBox(
              width: double.infinity,
              height: abbaButtonHeight,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final service = ref.read(subscriptionServiceProvider);
                    final success = await service.purchaseMonthly();
                    if (success) ref.invalidate(isPremiumProvider);
                  } catch (_) {
                    if (mounted) {
                      showAbbaSnackBar(context, message: l10n.errorPayment);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AbbaColors.premium,
                  foregroundColor: AbbaColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AbbaRadius.lg),
                  ),
                ),
                child: Text(
                  '💎 ${l10n.startPremium} — ${l10n.monthlyPrice}',
                  style: AbbaTypography.body.copyWith(
                    color: AbbaColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AbbaSpacing.sm),
            // Yearly CTA
            SizedBox(
              width: double.infinity,
              height: abbaButtonHeight,
              child: OutlinedButton(
                onPressed: () async {
                  try {
                    final service = ref.read(subscriptionServiceProvider);
                    final success = await service.purchaseYearly();
                    if (success) ref.invalidate(isPremiumProvider);
                  } catch (_) {
                    if (mounted) {
                      showAbbaSnackBar(context, message: l10n.errorPayment);
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AbbaColors.premium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AbbaRadius.lg),
                  ),
                ),
                child: Text(
                  '${l10n.yearlyPrice} (${l10n.yearlySave})',
                  style: AbbaTypography.body.copyWith(
                    color: AbbaColors.premium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Promotion end date — after this date, the promo banner is hidden.
  static final _promoEndDate = DateTime(2026, 7, 6); // 3 months from launch

  bool get _isPromoActive => DateTime.now().isBefore(_promoEndDate);

  Widget _buildGroupSection(AppLocalizations l10n) {
    return AbbaCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🌻', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AbbaSpacing.sm),
              Text(l10n.groupSection, style: AbbaTypography.h2),
            ],
          ),
          const SizedBox(height: AbbaSpacing.md),
          Text(
            l10n.noGroups,
            style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.muted),
          ),
          const SizedBox(height: AbbaSpacing.md),
          SizedBox(
            width: double.infinity,
            height: abbaButtonHeight,
            child: OutlinedButton.icon(
              onPressed: () {
                Share.share(l10n.groupInviteMessage);
              },
              icon: const Icon(Icons.person_add, color: AbbaColors.sage),
              label: Text(
                l10n.inviteFriends,
                style: AbbaTypography.body.copyWith(color: AbbaColors.sage),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AbbaColors.sage),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AbbaRadius.lg),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(AppLocalizations l10n) {
    final settingsAsync = ref.watch(notificationSettingsProvider);
    final settings = settingsAsync.valueOrNull;

    return AbbaCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AbbaSpacing.md,
              AbbaSpacing.md,
              AbbaSpacing.md,
              0,
            ),
            child: Row(
              children: [
                Icon(Icons.notifications_outlined, color: AbbaColors.warmBrown),
                const SizedBox(width: AbbaSpacing.sm),
                Text(l10n.notificationSetting, style: AbbaTypography.h2),
              ],
            ),
          ),
          // Morning reminder toggle + time
          _SettingsTile(
            icon: Icons.wb_sunny_outlined,
            title: l10n.morningPrayerReminder,
            trailing: Switch(
              value: settings?.morningReminder ?? true,
              onChanged: (v) {
                ref
                    .read(notificationServiceProvider)
                    .updateSettings(morningReminder: v);
                ref.invalidate(notificationSettingsProvider);
              },
              activeTrackColor: AbbaColors.sage,
            ),
          ),
          if (settings?.morningReminder ?? true) ...[
            _SettingsTile(
              icon: Icons.access_time,
              title: settings?.morningTime ?? '06:00',
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 6, minute: 0),
                );
                if (time != null) {
                  final formatted =
                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                  ref
                      .read(notificationServiceProvider)
                      .updateSettings(morningTime: formatted);
                  ref.invalidate(notificationSettingsProvider);
                }
              },
            ),
          ],
          const Divider(height: 1),
          // Evening reminder
          _SettingsTile(
            icon: Icons.nightlight_outlined,
            title: l10n.eveningGratitudeReminder,
            trailing: Switch(
              value: settings?.eveningReminder ?? false,
              onChanged: (v) {
                ref
                    .read(notificationServiceProvider)
                    .updateSettings(eveningReminder: v);
                ref.invalidate(notificationSettingsProvider);
              },
              activeTrackColor: AbbaColors.sage,
            ),
          ),
          const Divider(height: 1),
          // Streak reminder
          _SettingsTile(
            icon: Icons.local_fire_department_outlined,
            title: l10n.streakReminder,
            trailing: Switch(
              value: settings?.streakReminder ?? true,
              onChanged: (v) {
                ref
                    .read(notificationServiceProvider)
                    .updateSettings(streakReminder: v);
                ref.invalidate(notificationSettingsProvider);
              },
              activeTrackColor: AbbaColors.sage,
            ),
          ),
          const Divider(height: 1),
          // Weekly summary
          _SettingsTile(
            icon: Icons.calendar_view_week,
            title: l10n.weeklySummaryReminder,
            trailing: Switch(
              value: settings?.weeklySummary ?? true,
              onChanged: (v) {
                ref
                    .read(notificationServiceProvider)
                    .updateSettings(weeklySummary: v);
                ref.invalidate(notificationSettingsProvider);
              },
              activeTrackColor: AbbaColors.sage,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;

  const _StatBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AbbaTypography.h2),
        Text(label, style: AbbaTypography.caption),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AbbaColors.warmBrown),
      title: Text(
        title,
        style: AbbaTypography.body.copyWith(
          color: titleColor ?? AbbaColors.warmBrown,
        ),
      ),
      trailing:
          trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right, color: AbbaColors.muted)
              : null),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AbbaSpacing.md,
        vertical: AbbaSpacing.xs,
      ),
    );
  }
}

class _PlanColumn extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final bool isActive;
  final bool isPremium;

  const _PlanColumn({
    required this.title,
    required this.price,
    required this.features,
    this.isActive = false,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AbbaSpacing.md),
      decoration: BoxDecoration(
        color: isPremium
            ? AbbaColors.softGold.withValues(alpha: 0.1)
            : AbbaColors.cream,
        borderRadius: BorderRadius.circular(AbbaRadius.md),
        border: isActive
            ? Border.all(color: AbbaColors.sage, width: 2)
            : isPremium
            ? Border.all(color: AbbaColors.softGold, width: 2)
            : null,
      ),
      child: Column(
        children: [
          Text(
            title,
            style: AbbaTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(price, style: AbbaTypography.h2),
          const SizedBox(height: AbbaSpacing.sm),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(f, style: AbbaTypography.caption),
            ),
          ),
        ],
      ),
    );
  }
}
