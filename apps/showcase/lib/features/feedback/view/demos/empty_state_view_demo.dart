import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class EmptyStateViewDemo extends StatelessWidget {
  const EmptyStateViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EmptyStateView')),
      body: const Center(
        child: EmptyStateView(
          title: 'No Items Found',
          subtitle: 'Try adjusting your search or filters.',
          icon: Icons.inbox,
          actionLabel: 'Refresh',
        ),
      ),
    );
  }
}
