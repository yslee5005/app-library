import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class ExpandableTextDemo extends StatelessWidget {
  const ExpandableTextDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ExpandableText')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('2 lines max', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const ExpandableText(
              text:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do '
                  'eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim '
                  'ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut '
                  'aliquip ex ea commodo consequat. Duis aute irure dolor in '
                  'reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla '
                  'pariatur. Excepteur sint occaecat cupidatat non proident, sunt in '
                  'culpa qui officia deserunt mollit anim id est laborum.',
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            Text('4 lines max', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const ExpandableText(
              text:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do '
                  'eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim '
                  'ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut '
                  'aliquip ex ea commodo consequat. Duis aute irure dolor in '
                  'reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla '
                  'pariatur. Excepteur sint occaecat cupidatat non proident, sunt in '
                  'culpa qui officia deserunt mollit anim id est laborum.',
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
