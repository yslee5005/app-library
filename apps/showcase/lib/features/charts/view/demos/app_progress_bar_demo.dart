import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class AppProgressBarDemo extends StatelessWidget {
  const AppProgressBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppProgressBar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Linear', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            const AppProgressBar(value: 0.75, label: 'Storage'),
            const SizedBox(height: 12),
            const AppProgressBar(value: 0.45, label: 'Upload'),
            const SizedBox(height: 12),
            const AppProgressBar(value: 0.20, label: 'Memory'),
            const SizedBox(height: 32),
            Text('Circular', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                AppProgressBar(
                  value: 0.85,
                  type: ProgressBarType.circular,
                  label: '85%',
                ),
                AppProgressBar(
                  value: 0.50,
                  type: ProgressBarType.circular,
                  label: '50%',
                ),
                AppProgressBar(
                  value: 0.25,
                  type: ProgressBarType.circular,
                  label: '25%',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
