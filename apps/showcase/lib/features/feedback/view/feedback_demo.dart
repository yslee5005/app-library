import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class FeedbackDemo extends StatelessWidget {
  const FeedbackDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(context, 'SkeletonLoader'),
          Row(
            children: [
              const SkeletonLoader(
                shape: SkeletonShape.circle,
                width: 48,
                height: 48,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SkeletonLoader(height: 14, width: 120),
                    SizedBox(height: 8),
                    SkeletonLoader(height: 14),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const SkeletonLoader(shape: SkeletonShape.text, lineCount: 4),
          const SizedBox(height: 24),
          _sectionTitle(context, 'ShimmerWidget'),
          ShimmerWidget(
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'EmptyStateView'),
          const EmptyStateView(
            title: 'No Items Found',
            subtitle: 'Try adjusting your search or filters.',
            icon: Icons.inbox,
            actionLabel: 'Refresh',
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'ErrorStateView'),
          ErrorStateView(
            message: 'Something went wrong. Please try again.',
            onRetry: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Retry tapped')),
              );
            },
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'BadgeWidget'),
          Row(
            children: [
              BadgeWidget(
                count: 5,
                child: Icon(Icons.mail,
                    size: 32, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 24),
              BadgeWidget(
                showDot: true,
                child: Icon(Icons.notifications,
                    size: 32, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 24),
              BadgeWidget(
                count: 99,
                child: Icon(Icons.chat,
                    size: 32, color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'AppDialog'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () => AppDialog.show(
                  context,
                  title: 'Info',
                  content: 'This is an informational dialog.',
                  variant: AppDialogVariant.info,
                  primaryLabel: 'OK',
                ),
                child: const Text('Info'),
              ),
              ElevatedButton(
                onPressed: () => AppDialog.show(
                  context,
                  title: 'Success',
                  content: 'Operation completed successfully!',
                  variant: AppDialogVariant.success,
                  primaryLabel: 'Great',
                ),
                child: const Text('Success'),
              ),
              ElevatedButton(
                onPressed: () => AppDialog.show(
                  context,
                  title: 'Error',
                  content: 'An error occurred.',
                  variant: AppDialogVariant.error,
                  primaryLabel: 'Dismiss',
                ),
                child: const Text('Error'),
              ),
              ElevatedButton(
                onPressed: () => AppDialog.show(
                  context,
                  title: 'Confirm',
                  content: 'Are you sure you want to proceed?',
                  variant: AppDialogVariant.confirm,
                  primaryLabel: 'Yes',
                  secondaryLabel: 'No',
                ),
                child: const Text('Confirm'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'AppToast'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () => AppToast.show(
                  context,
                  message: 'Info toast message',
                  variant: AppToastVariant.info,
                ),
                child: const Text('Info Toast'),
              ),
              ElevatedButton(
                onPressed: () => AppToast.show(
                  context,
                  message: 'Success toast message',
                  variant: AppToastVariant.success,
                ),
                child: const Text('Success Toast'),
              ),
              ElevatedButton(
                onPressed: () => AppToast.show(
                  context,
                  message: 'Error toast message',
                  variant: AppToastVariant.error,
                ),
                child: const Text('Error Toast'),
              ),
              ElevatedButton(
                onPressed: () => AppToast.show(
                  context,
                  message: 'Warning toast message',
                  variant: AppToastVariant.warning,
                ),
                child: const Text('Warning Toast'),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
