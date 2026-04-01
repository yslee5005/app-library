import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class ShimmerWidgetDemo extends StatelessWidget {
  const ShimmerWidgetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ShimmerWidget')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shimmer effect',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ShimmerWidget(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ShimmerWidget(
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
