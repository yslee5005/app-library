import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class SignUpFormDemo extends StatelessWidget {
  const SignUpFormDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SignUpForm')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SignUpForm(
          onSignUp: (name, email, password) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Sign up: $name ($email)')));
          },
        ),
      ),
    );
  }
}
