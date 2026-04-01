import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class BadgeWidgetDemo extends StatelessWidget {
  const BadgeWidgetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BadgeWidget')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Badge with count',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                BadgeWidget(
                  count: 5,
                  child: Icon(Icons.mail,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: 24),
                BadgeWidget(
                  count: 99,
                  child: Icon(Icons.chat,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Dot badge',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            BadgeWidget(
              showDot: true,
              child: Icon(Icons.notifications,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
