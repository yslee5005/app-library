import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class AppButtonDemo extends StatelessWidget {
  const AppButtonDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppButton')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppButton(
              label: 'Primary',
              onPressed: () {},
              expand: true,
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'Secondary',
              variant: AppButtonVariant.secondary,
              onPressed: () {},
              expand: true,
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'Outline',
              variant: AppButtonVariant.outline,
              onPressed: () {},
              expand: true,
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'Text',
              variant: AppButtonVariant.text,
              onPressed: () {},
              expand: true,
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'With Icon',
              icon: Icons.send,
              onPressed: () {},
              expand: true,
            ),
            const SizedBox(height: 8),
            const AppButton(
              label: 'Loading',
              isLoading: true,
              expand: true,
            ),
            const SizedBox(height: 8),
            const AppButton(label: 'Disabled', expand: true),
          ],
        ),
      ),
    );
  }
}
