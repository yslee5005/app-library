import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class StatCardDemo extends StatelessWidget {
  const StatCardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StatCard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    value: '1.2K',
                    label: 'Followers',
                    trend: TrendDirection.up,
                    trendValue: '+12%',
                    icon: Icons.people,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: StatCard(
                    value: '342',
                    label: 'Posts',
                    trend: TrendDirection.neutral,
                    trendValue: '0%',
                    icon: Icons.article,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    value: '4.8',
                    label: 'Rating',
                    trend: TrendDirection.up,
                    trendValue: '+0.3',
                    icon: Icons.star,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: StatCard(
                    value: '89',
                    label: 'Comments',
                    trend: TrendDirection.down,
                    trendValue: '-5%',
                    icon: Icons.comment,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
