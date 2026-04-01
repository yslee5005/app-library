import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class ForgotPasswordFormDemo extends StatelessWidget {
  const ForgotPasswordFormDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ForgotPasswordForm')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ForgotPasswordForm(
          description: 'Enter your email to receive a reset link.',
          onSubmit: (email) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Reset link sent to $email')),
            );
          },
        ),
      ),
    );
  }
}
