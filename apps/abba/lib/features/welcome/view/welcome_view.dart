import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  Future<void> _onGetStarted(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_welcome', true);
    if (context.mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.xl),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo area
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AbbaColors.sage.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '🌿',
                    style: AbbaTypography.hero.copyWith(fontSize: 56),
                  ),
                ),
              ),
              const SizedBox(height: AbbaSpacing.lg),
              // App name
              Text(
                l10n.appName,
                style: AbbaTypography.hero.copyWith(
                  fontSize: 40,
                  color: AbbaColors.sage,
                ),
              ),
              const SizedBox(height: AbbaSpacing.lg),
              // Title
              Text(
                l10n.welcomeTitle,
                style: AbbaTypography.h1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AbbaSpacing.md),
              // Subtitle
              Text(
                l10n.welcomeSubtitle,
                style: AbbaTypography.body.copyWith(color: AbbaColors.muted),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              // Get Started button
              AbbaButton(
                label: l10n.getStarted,
                onPressed: () => _onGetStarted(context),
                isHero: true,
              ),
              const SizedBox(height: AbbaSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
