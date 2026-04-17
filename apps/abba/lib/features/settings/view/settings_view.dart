import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/user_profile.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_card.dart';
import '../../../widgets/abba_snackbar.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final isAnon = ref.watch(isAnonymousProvider);
    final premiumAsync = ref.watch(isPremiumProvider);
    final isPremium = premiumAsync.value ?? false;

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        title: Text(l10n.settingsTitle, style: AbbaTypography.h1),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AbbaSpacing.md,
          vertical: AbbaSpacing.md,
        ),
        children: [
          // ── Profile card ──────────────────────────────────────────
          _buildProfileCard(l10n, profileAsync, isAnon),
          const SizedBox(height: AbbaSpacing.lg),

          // ── Account section ───────────────────────────────────────
          _SectionHeader(title: l10n.linkAccountTitle),
          const SizedBox(height: AbbaSpacing.sm),
          AbbaCard(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Login / Link account
                _SettingsRow(
                  icon: Icons.person_outline,
                  title: isAnon ? l10n.linkAccountTitle : l10n.linkAccountTitle,
                  trailing: isAnon
                      ? const Icon(
                          Icons.chevron_right,
                          color: AbbaColors.muted,
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.linkAccountSuccess
                                  .replaceAll('!', '')
                                  .trim(),
                              style: AbbaTypography.caption.copyWith(
                                color: AbbaColors.sage,
                              ),
                            ),
                            const SizedBox(width: AbbaSpacing.xs),
                            const Icon(
                              Icons.chevron_right,
                              color: AbbaColors.muted,
                            ),
                          ],
                        ),
                  onTap: () {
                    if (isAnon) {
                      _showLinkAccountSheet(context, l10n);
                    }
                  },
                ),
                const Divider(height: 1, indent: 56),
                // Membership
                _SettingsRow(
                  icon: Icons.workspace_premium_outlined,
                  title: l10n.membershipTitle,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AbbaSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isPremium
                              ? AbbaColors.sage.withValues(alpha: 0.15)
                              : AbbaColors.muted.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AbbaRadius.sm),
                        ),
                        child: Text(
                          isPremium ? l10n.premiumPlan : l10n.freePlan,
                          style: AbbaTypography.caption.copyWith(
                            color:
                                isPremium ? AbbaColors.sage : AbbaColors.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: AbbaSpacing.xs),
                      const Icon(
                        Icons.chevron_right,
                        color: AbbaColors.muted,
                      ),
                    ],
                  ),
                  onTap: () => context.go('/settings/membership'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AbbaSpacing.lg),

          // ── Settings section ──────────────────────────────────────
          _SectionHeader(title: l10n.settingsTitle),
          const SizedBox(height: AbbaSpacing.sm),
          AbbaCard(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // AI Voice
                _SettingsRow(
                  icon: Icons.record_voice_over_outlined,
                  title: l10n.aiVoiceSetting,
                  trailing: _buildVoiceDropdown(l10n),
                ),
                const Divider(height: 1, indent: 56),
                // Language
                _SettingsRow(
                  icon: Icons.language,
                  title: l10n.languageSetting,
                  trailing: _buildLanguageDropdown(locale),
                ),
                const Divider(height: 1, indent: 56),
                // Dark mode (disabled for MVP — hardcoded AbbaColors.cream backgrounds clash)
                _SettingsRow(
                  icon: Icons.dark_mode_outlined,
                  title: l10n.darkModeSetting,
                  trailing: Text(
                    'Coming soon',
                    style: AbbaTypography.caption.copyWith(
                      color: AbbaColors.muted,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 56),
                // Notification settings
                _SettingsRow(
                  icon: Icons.notifications_outlined,
                  title: l10n.notificationSetting,
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AbbaColors.muted,
                  ),
                  onTap: () => context.go('/settings/notifications'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AbbaSpacing.lg),

          // ── More section ──────────────────────────────────────────
          const _SectionHeader(title: ''),
          const SizedBox(height: AbbaSpacing.sm),
          AbbaCard(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsRow(
                  icon: Icons.help_outline,
                  title: l10n.helpCenter,
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AbbaColors.muted,
                  ),
                  onTap: () => _launchUrlSafe(Uri.parse('https://abba.ystech.app/help')),
                ),
                const Divider(height: 1, indent: 56),
                _SettingsRow(
                  icon: Icons.description_outlined,
                  title: l10n.termsOfService,
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AbbaColors.muted,
                  ),
                  onTap: () => _launchUrlSafe(Uri.parse('https://abba.ystech.app/terms')),
                ),
                const Divider(height: 1, indent: 56),
                _SettingsRow(
                  icon: Icons.privacy_tip_outlined,
                  title: l10n.privacyPolicy,
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AbbaColors.muted,
                  ),
                  onTap: () => _launchUrlSafe(Uri.parse('https://abba.ystech.app/privacy')),
                ),
                if (!isAnon) ...[
                  const Divider(height: 1, indent: 56),
                  _SettingsRow(
                    icon: Icons.logout,
                    title: l10n.logout,
                    titleColor: AbbaColors.error,
                    onTap: () => _showLogoutDialog(context, l10n),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AbbaSpacing.lg),

          // ── Version ───────────────────────────────────────────────
          Center(
            child: Text(
              l10n.appVersion('1.0.0'),
              style: AbbaTypography.caption,
            ),
          ),
          const SizedBox(height: AbbaSpacing.xl),
        ],
      ),
    );
  }

  // ── Profile card ────────────────────────────────────────────────────
  Widget _buildProfileCard(
    AppLocalizations l10n,
    AsyncValue<UserProfile> profileAsync,
    bool isAnon,
  ) {
    return profileAsync.when(
      data: (profile) => AbbaCard(
        margin: EdgeInsets.zero,
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AbbaColors.sage.withValues(alpha: 0.2),
              child: Text(
                isAnon
                    ? '\u{1F64F}'
                    : (profile.name.isNotEmpty
                        ? profile.name[0].toUpperCase()
                        : '?'),
                style: AbbaTypography.h2.copyWith(color: AbbaColors.sage),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isAnon && profile.email.isNotEmpty)
                    Text(
                      profile.email,
                      style: AbbaTypography.caption.copyWith(
                        color: AbbaColors.muted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  else if (isAnon)
                    Text(
                      l10n.linkAccountDescription,
                      style: AbbaTypography.caption.copyWith(
                        color: AbbaColors.sage,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox(height: 72),
      error: (_, _) => const SizedBox(height: 72),
    );
  }

  // ── Voice dropdown ──────────────────────────────────────────────────
  Widget _buildVoiceDropdown(AppLocalizations l10n) {
    final voiceLabels = <String, String>{
      'warm': l10n.voiceWarm,
      'calm': l10n.voiceCalm,
      'strong': l10n.voiceStrong,
    };

    final voicePref = ref.watch(voicePreferenceProvider);

    return DropdownButton<String>(
      value: voicePref,
      underline: const SizedBox.shrink(),
      icon: const SizedBox.shrink(),
      items: voiceLabels.entries
          .map(
            (e) => DropdownMenuItem(
              value: e.key,
              child: Text(e.value, style: AbbaTypography.bodySmall),
            ),
          )
          .toList(),
      onChanged: (v) async {
        if (v != null) {
          ref.read(voicePreferenceProvider.notifier).state = v;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('voice_preference', v);
        }
      },
    );
  }

  // ── Language dropdown ───────────────────────────────────────────────
  Widget _buildLanguageDropdown(String locale) {
    const languages = <String, String>{
      'en': 'English',
      'ko': '\uD55C\uAD6D\uC5B4',
      'ja': '\u65E5\u672C\u8A9E',
      'es': 'Espa\u00F1ol',
      'zh': '\u4E2D\u6587',
      'pt': 'Portugu\u00EAs',
      'fr': 'Fran\u00E7ais',
      'hi': '\u0939\u093F\u0928\u094D\u0926\u0940',
      'fil': 'Filipino',
      'sw': 'Kiswahili',
      'de': 'Deutsch',
      'it': 'Italiano',
      'pl': 'Polski',
      'ru': '\u0420\u0443\u0441\u0441\u043A\u0438\u0439',
      'id': 'Indonesia',
      'uk': '\u0423\u043A\u0440\u0430\u0457\u043D\u0441\u044C\u043A\u0430',
      'ro': 'Rom\u00E2n\u0103',
      'nl': 'Nederlands',
      'hu': 'Magyar',
      'cs': '\u010Ce\u0161tina',
      'vi': 'Ti\u1EBFng Vi\u1EC7t',
      'th': '\u0E44\u0E17\u0E22',
      'tr': 'T\u00FCrk\u00E7e',
      'ar': '\u0627\u0644\u0639\u0631\u0628\u064A\u0629',
      'he': '\u05E2\u05D1\u05E8\u05D9\u05EA',
      'el': '\u0395\u03BB\u03BB\u03B7\u03BD\u03B9\u03BA\u03AC',
      'sv': 'Svenska',
      'no': 'Norsk',
      'da': 'Dansk',
      'fi': 'Suomi',
      'hr': 'Hrvatski',
      'sk': 'Sloven\u010Dina',
      'ms': 'Bahasa Melayu',
      'am': '\u12A0\u121B\u122D\u129B',
      'my': '\u1019\u103C\u1014\u103A\u1019\u102C',
    };

    return DropdownButton<String>(
      value: locale,
      underline: const SizedBox.shrink(),
      icon: const SizedBox.shrink(),
      items: languages.entries
          .map(
            (e) => DropdownMenuItem(
              value: e.key,
              child: Text(e.value, style: AbbaTypography.bodySmall),
            ),
          )
          .toList(),
      onChanged: (v) async {
        if (v != null) {
          ref.read(localeProvider.notifier).state = v;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('locale', v);
        }
      },
    );
  }

  // ── URL launch with fallback ────────────────────────────────────────
  Future<void> _launchUrlSafe(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Coming soon')),
        );
      }
    }
  }

  // ── Link account bottom sheet ───────────────────────────────────────
  void _showLinkAccountSheet(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AbbaColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AbbaRadius.xl),
        ),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AbbaSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AbbaColors.muted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AbbaSpacing.lg),
              Text(l10n.linkAccountTitle, style: AbbaTypography.h2),
              const SizedBox(height: AbbaSpacing.sm),
              Text(
                l10n.linkAccountDescription,
                style:
                    AbbaTypography.bodySmall.copyWith(color: AbbaColors.muted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AbbaSpacing.lg),
              // Apple login button
              SizedBox(
                width: double.infinity,
                height: abbaButtonHeight,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.apple),
                  label: Text(l10n.linkWithApple),
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    _linkAccount('apple');
                  },
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
              // Google login button
              SizedBox(
                width: double.infinity,
                height: abbaButtonHeight,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.g_mobiledata),
                  label: Text(l10n.linkWithGoogle),
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    _linkAccount('google');
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AbbaColors.sage),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AbbaRadius.lg),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AbbaSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _linkAccount(String provider) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final notifier = ref.read(authNotifierProvider.notifier);
      if (provider == 'apple') {
        await notifier.linkWithApple();
      } else {
        await notifier.linkWithGoogle();
      }
      ref.invalidate(userProfileProvider);
      if (mounted) {
        setState(() {});
        showAbbaSnackBar(context, message: l10n.linkAccountSuccess);
      }
    } catch (e) {
      if (mounted) {
        showAbbaSnackBar(context, message: l10n.errorGeneric);
      }
    }
  }

  // ── Logout dialog ───────────────────────────────────────────────────
  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AbbaColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AbbaRadius.lg),
        ),
        title: Text(l10n.logout, style: AbbaTypography.h2),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancelAnytime.split(' ').first, // "언제든" → just use first word as cancel
              style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.muted),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) context.go('/welcome');
            },
            child: Text(
              l10n.logout,
              style:
                  AbbaTypography.bodySmall.copyWith(color: AbbaColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section header ──────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(left: AbbaSpacing.xs),
      child: Text(
        title,
        style: AbbaTypography.label.copyWith(
          color: AbbaColors.muted,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Settings row ────────────────────────────────────────────────────────
class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _SettingsRow({
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AbbaSpacing.md,
        vertical: AbbaSpacing.xs,
      ),
    );
  }
}
