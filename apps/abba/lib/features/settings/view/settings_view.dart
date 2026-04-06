import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/providers.dart';
import '../../../services/auth_service.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_card.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  bool _notificationsEnabled = true;
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
        title: Text(
          '${l10n.settingsTitle} ⚙️',
          style: AbbaTypography.h1,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AbbaSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            profileAsync.when(
              data: (profile) => AbbaCard(
                margin: const EdgeInsets.only(bottom: AbbaSpacing.md),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor:
                          AbbaColors.sage.withValues(alpha: 0.2),
                      child: Text(
                        profile.name[0].toUpperCase(),
                        style: AbbaTypography.h1.copyWith(
                          color: AbbaColors.sage,
                        ),
                      ),
                    ),
                    const SizedBox(width: AbbaSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profile.name, style: AbbaTypography.h2),
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
            ),

            // Premium card
            _buildPremiumCard(l10n),
            const SizedBox(height: AbbaSpacing.md),

            // Settings list
            AbbaCard(
              margin: const EdgeInsets.only(bottom: AbbaSpacing.md),
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  // Notifications
                  _SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: l10n.notificationSetting,
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (v) =>
                          setState(() => _notificationsEnabled = v),
                      activeTrackColor: AbbaColors.sage,
                    ),
                  ),
                  const Divider(height: 1),
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
                          child: Text(l10n.voiceWarm,
                              style: AbbaTypography.bodySmall),
                        ),
                        DropdownMenuItem(
                          value: 'calm',
                          child: Text(l10n.voiceCalm,
                              style: AbbaTypography.bodySmall),
                        ),
                        DropdownMenuItem(
                          value: 'strong',
                          child: Text(l10n.voiceStrong,
                              style: AbbaTypography.bodySmall),
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
                        DropdownMenuItem(
                          value: 'en',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: 'ko',
                          child: Text('한국어'),
                        ),
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

  Widget _buildPremiumCard(AppLocalizations l10n) {
    return AbbaCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Promo banner
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
            child: Text(
              '🌸 ${l10n.launchPromo}',
              style: AbbaTypography.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AbbaSpacing.md),
          // Price comparison
          Row(
            children: [
              Expanded(
                child: _PlanColumn(
                  title: l10n.freePlan,
                  price: '\$0',
                  features: const ['1x/day', '📜', '📖', '✍️'],
                  isActive: true,
                ),
              ),
              const SizedBox(width: AbbaSpacing.md),
              Expanded(
                child: _PlanColumn(
                  title: l10n.premiumPlan,
                  price: l10n.monthlyPrice,
                  features: const [
                    'Unlimited',
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
          // CTA button
          SizedBox(
            width: double.infinity,
            height: abbaButtonHeight,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.comingSoon)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AbbaColors.premium,
                foregroundColor: AbbaColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AbbaRadius.lg),
                ),
              ),
              child: Text(
                '💎 ${l10n.startPremium}',
                style: AbbaTypography.body.copyWith(
                  color: AbbaColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
      trailing: trailing ??
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
            style: AbbaTypography.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
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
