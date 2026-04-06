import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/providers.dart';
import '../../../services/auth_service.dart';
import '../../../theme/abba_theme.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    Future<void> handleSignIn(Future<void> Function() signIn) async {
      try {
        ref.read(authStateProvider.notifier).state =
            const AbbaAuthState(status: AuthStatus.loading);
        await signIn();
        // Auth state will be updated by the service → redirect handles navigation
      } catch (e) {
        ref.read(authStateProvider.notifier).state =
            AbbaAuthState(status: AuthStatus.unauthenticated, error: '$e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$e')),
          );
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
                onTap: () => handleSignIn(() async {
                  final auth = ref.read(authServiceProvider);
                  final profile = await auth.signInWithApple();
                  ref.read(authStateProvider.notifier).state = AbbaAuthState(
                    status: AuthStatus.authenticated,
                    user: profile,
                  );
                  if (context.mounted) context.go('/home');
                }),
              ),
              const SizedBox(height: AbbaSpacing.md),
              _LoginButton(
                label: l10n.signInWithGoogle,
                icon: Icons.g_mobiledata,
                backgroundColor: AbbaColors.white,
                textColor: AbbaColors.warmBrown,
                onTap: () => handleSignIn(() async {
                  final auth = ref.read(authServiceProvider);
                  final profile = await auth.signInWithGoogle();
                  ref.read(authStateProvider.notifier).state = AbbaAuthState(
                    status: AuthStatus.authenticated,
                    user: profile,
                  );
                  if (context.mounted) context.go('/home');
                }),
              ),
              const SizedBox(height: AbbaSpacing.md),
              _LoginButton(
                label: l10n.signInWithEmail,
                icon: Icons.email_outlined,
                backgroundColor: AbbaColors.sage,
                textColor: AbbaColors.white,
                onTap: () => handleSignIn(() async {
                  final auth = ref.read(authServiceProvider);
                  final profile = await auth.signInWithEmail(
                    'demo@abba.app',
                    'demo1234',
                  );
                  ref.read(authStateProvider.notifier).state = AbbaAuthState(
                    status: AuthStatus.authenticated,
                    user: profile,
                  );
                  if (context.mounted) context.go('/home');
                }),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
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
