import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class LoginFormDemo extends StatelessWidget {
  const LoginFormDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LoginForm')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: LoginForm(
          onLogin: (email, password) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login: $email')),
            );
          },
          onGoogleLogin: () {},
          onAppleLogin: () {},
          onForgotPassword: () {},
        ),
      ),
    );
  }
}
