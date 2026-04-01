import 'package:flutter/material.dart';

import 'demos/forgot_password_form_demo.dart';
import 'demos/login_form_demo.dart';
import 'demos/onboarding_carousel_demo.dart';
import 'demos/sign_up_form_demo.dart';

class OnboardingDemo extends StatelessWidget {
  const OnboardingDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.swipe),
            title: const Text('OnboardingCarousel'),
            subtitle: const Text('Swipeable pages with indicator'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const OnboardingCarouselDemo(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('LoginForm'),
            subtitle: const Text('Email + password + social login'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const LoginFormDemo()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('SignUpForm'),
            subtitle: const Text('Name, email, password registration'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const SignUpFormDemo()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: const Text('ForgotPasswordForm'),
            subtitle: const Text('Email-based password reset'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const ForgotPasswordFormDemo(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
