import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class AppAvatarDemo extends StatelessWidget {
  const AppAvatarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppAvatar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sizes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              children: const [
                AppAvatar(name: 'John Doe', size: AvatarSize.sm),
                SizedBox(width: 16),
                AppAvatar(name: 'John Doe', size: AvatarSize.md),
                SizedBox(width: 16),
                AppAvatar(name: 'John Doe', size: AvatarSize.lg),
              ],
            ),
            const SizedBox(height: 24),
            Text('Different names',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              children: const [
                AppAvatar(name: 'Alice', size: AvatarSize.md),
                SizedBox(width: 16),
                AppAvatar(name: 'Bob Smith', size: AvatarSize.md),
                SizedBox(width: 16),
                AppAvatar(name: 'Carol', size: AvatarSize.md),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
