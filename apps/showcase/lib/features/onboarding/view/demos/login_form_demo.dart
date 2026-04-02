import 'package:app_lib_auth/auth.dart';
import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginFormDemo extends ConsumerWidget {
  const LoginFormDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('LoginForm')),
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (state) => switch (state) {
          Authenticated(:final user) => _AuthenticatedView(
              user: user,
              onSignOut: () =>
                  ref.read(authNotifierProvider.notifier).signOut(),
            ),
          AuthLoading() =>
            const Center(child: CircularProgressIndicator()),
          _ => SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: LoginForm(
                onLogin: (email, password) {
                  ref.read(authNotifierProvider.notifier).signInWithEmail(
                        email: email,
                        password: password,
                      );
                },
                onGoogleLogin: () {
                  ref.read(authNotifierProvider.notifier).signInWithGoogle();
                },
                onAppleLogin: () {
                  ref.read(authNotifierProvider.notifier).signInWithApple();
                },
                onForgotPassword: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Forgot password (mock)')),
                  );
                },
              ),
            ),
        },
      ),
    );
  }
}

class _AuthenticatedView extends StatelessWidget {
  const _AuthenticatedView({required this.user, required this.onSignOut});

  final UserProfile user;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 64, color: colors.primary),
            const SizedBox(height: 16),
            Text('Welcome!', style: textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              user.displayName ?? 'User',
              style: textTheme.titleMedium,
            ),
            Text(
              user.email ?? '',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            Text(
              'Provider: ${user.provider}',
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onSignOut,
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
