import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../sample_data/sample_data.dart';

class OnboardingDemo extends StatelessWidget {
  const OnboardingDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(context, 'OnboardingCarousel'),
          SizedBox(
            height: 380,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: OnboardingCarousel(
                pages: SampleData.onboardingPages
                    .map(
                      (p) => OnboardingPage(
                        title: p['title']!,
                        subtitle: p['subtitle']!,
                        image: Icon(
                          Icons.widgets,
                          size: 80,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                    .toList(),
                onFinish: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Onboarding finished!')),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'LoginForm'),
          LoginForm(
            onLogin: (email, password) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Login: $email')),
              );
            },
            onGoogleLogin: () {},
            onAppleLogin: () {},
            onForgotPassword: () {},
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'SignUpForm'),
          SignUpForm(
            onSignUp: (name, email, password) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sign up: $name ($email)')),
              );
            },
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'ForgotPasswordForm'),
          ForgotPasswordForm(
            description: 'Enter your email to receive a reset link.',
            onSubmit: (email) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reset link sent to $email')),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
