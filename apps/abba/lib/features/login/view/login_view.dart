import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/providers.dart';
import '../../../services/error_logging_service.dart';
import '../../../theme/abba_theme.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    Future<void> handleSignIn(
      Future<void> Function() signIn,
      String provider,
    ) async {
      try {
        await signIn();
        ErrorLoggingService.addBreadcrumb(
          'Login success: $provider',
          category: 'auth',
        );
        if (context.mounted) context.go('/home');
      } catch (e, stackTrace) {
        ErrorLoggingService.captureException(e, stackTrace);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$e')));
        }
      }
    }

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.xl),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Text(
                l10n.loginTitle,
                style: AbbaTypography.h1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AbbaSpacing.sm),
              Text(
                l10n.loginSubtitle,
                style: AbbaTypography.body.copyWith(color: AbbaColors.muted),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              _LoginButton(
                label: l10n.signInWithApple,
                icon: Icons.apple,
                backgroundColor: AbbaColors.warmBrown,
                textColor: AbbaColors.white,
                onTap: () => handleSignIn(
                  () => ref
                      .read(authNotifierProvider.notifier)
                      .signInWithApple(),
                  'Apple',
                ),
              ),
              const SizedBox(height: AbbaSpacing.md),
              _LoginButton(
                label: l10n.signInWithGoogle,
                icon: Icons.g_mobiledata,
                backgroundColor: AbbaColors.white,
                textColor: AbbaColors.warmBrown,
                onTap: () => handleSignIn(
                  () => ref
                      .read(authNotifierProvider.notifier)
                      .signInWithGoogle(),
                  'Google',
                ),
              ),
              const SizedBox(height: AbbaSpacing.md),
              _LoginButton(
                label: l10n.signInWithEmail,
                icon: Icons.email_outlined,
                backgroundColor: AbbaColors.sageDark,
                textColor: AbbaColors.white,
                onTap: () => handleSignIn(
                  () async {
                    final credentials = await _showEmailDialog(context, l10n);
                    if (credentials == null) return;
                    await ref
                        .read(authNotifierProvider.notifier)
                        .signInWithEmail(
                          email: credentials.$1,
                          password: credentials.$2,
                        );
                  },
                  'Email',
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

Future<(String, String)?> _showEmailDialog(
  BuildContext context,
  AppLocalizations l10n,
) {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  return showDialog<(String, String)>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.signInWithEmail, style: AbbaTypography.h2),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: AbbaTypography.body,
            decoration: InputDecoration(
              labelText: l10n.emailLabel,
              labelStyle: AbbaTypography.bodySmall,
            ),
          ),
          const SizedBox(height: AbbaSpacing.md),
          TextField(
            controller: passwordController,
            obscureText: true,
            style: AbbaTypography.body,
            decoration: InputDecoration(
              labelText: l10n.passwordLabel,
              labelStyle: AbbaTypography.bodySmall,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            final email = emailController.text.trim();
            final password = passwordController.text;
            if (email.isNotEmpty && password.length >= 6) {
              Navigator.pop(context, (email, password));
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: AbbaColors.sageDark),
          child: Text(
            l10n.signIn,
            style: const TextStyle(color: AbbaColors.white),
          ),
        ),
      ],
    ),
  );
}

class _LoginButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const _LoginButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 28, color: textColor),
        label: Text(
          label,
          style: AbbaTypography.body.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: backgroundColor == AbbaColors.white ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AbbaRadius.lg),
            side: backgroundColor == AbbaColors.white
                ? const BorderSide(color: AbbaColors.muted, width: 0.5)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
