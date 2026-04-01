import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../sample_data/sample_data.dart';

class ChartsDemo extends StatelessWidget {
  const ChartsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Charts')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(context, 'StatCard'),
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
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  value: '4.8',
                  label: 'Rating',
                  trend: TrendDirection.up,
                  trendValue: '+0.3',
                  icon: Icons.star,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'AppProgressBar (linear)'),
          const AppProgressBar(value: 0.75, label: 'Storage'),
          const SizedBox(height: 12),
          const AppProgressBar(value: 0.45, label: 'Upload'),
          const SizedBox(height: 12),
          const AppProgressBar(value: 0.20, label: 'Memory'),
          const SizedBox(height: 24),
          _sectionTitle(context, 'AppProgressBar (circular)'),
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
          const SizedBox(height: 24),
          _sectionTitle(context, 'HeatmapCalendar'),
          HeatmapCalendar(
            data: SampleData.heatmapData,
            weeks: 17,
            onDayTap: (date, value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${date.month}/${date.day}: $value activities',
                  ),
                ),
              );
            },
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
