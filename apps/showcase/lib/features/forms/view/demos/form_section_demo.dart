import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class FormSectionDemo extends StatelessWidget {
  const FormSectionDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FormSection')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FormSection(
              title: 'Personal Info',
              description: 'Enter your basic information.',
              children: const [
                AppTextField(label: 'First Name', hint: 'John'),
                SizedBox(height: 8),
                AppTextField(label: 'Last Name', hint: 'Doe'),
              ],
            ),
            const SizedBox(height: 24),
            FormSection(
              title: 'Contact',
              description: 'How can we reach you?',
              children: const [
                AppTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  prefixIcon: Icons.email,
                ),
                SizedBox(height: 8),
                AppTextField(
                  label: 'Phone',
                  hint: '+1 (555) 000-0000',
                  prefixIcon: Icons.phone,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
