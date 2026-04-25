import 'package:flutter/material.dart';

import 'demos/app_dialog_demo.dart';
import 'demos/app_toast_demo.dart';
import 'demos/badge_widget_demo.dart';
import 'demos/empty_state_view_demo.dart';
import 'demos/error_state_view_demo.dart';
import 'demos/shimmer_widget_demo.dart';
import 'demos/skeleton_loader_demo.dart';

class FeedbackDemo extends StatelessWidget {
  const FeedbackDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.rectangle_outlined),
            title: const Text('SkeletonLoader'),
            subtitle: const Text('Placeholder skeleton shapes'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const SkeletonLoaderDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.gradient),
            title: const Text('ShimmerWidget'),
            subtitle: const Text('Animated shimmer loading effect'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const ShimmerWidgetDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.inbox),
            title: const Text('EmptyStateView'),
            subtitle: const Text('Empty state with icon and action'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const EmptyStateViewDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.error_outline),
            title: const Text('ErrorStateView'),
            subtitle: const Text('Error state with retry button'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const ErrorStateViewDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.dialpad),
            title: const Text('AppDialog'),
            subtitle: const Text('Info, success, error, confirm dialogs'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const AppDialogDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('AppToast'),
            subtitle: const Text('Toast/snackbar variants'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const AppToastDemo()),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active),
            title: const Text('BadgeWidget'),
            subtitle: const Text('Count badge and dot badge on icons'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const BadgeWidgetDemo(),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
