import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class AppTextFieldDemo extends StatelessWidget {
  const AppTextFieldDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppTextField')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            AppTextField(
              label: 'Name',
              hint: 'Enter your name',
              prefixIcon: Icons.person,
            ),
            SizedBox(height: 12),
            AppTextField(
              label: 'Email',
              hint: 'you@example.com',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 12),
            AppTextField(
              label: 'Password',
              hint: 'Enter password',
              prefixIcon: Icons.lock,
              obscure: true,
            ),
            SizedBox(height: 12),
            AppTextField(
              label: 'Bio',
              hint: 'Tell us about yourself',
              maxLines: 3,
            ),
            SizedBox(height: 12),
            AppTextField(
              label: 'Disabled',
              hint: 'Cannot edit',
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }
}
