import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../sample_data/sample_data.dart';

class HeatmapCalendarDemo extends StatelessWidget {
  const HeatmapCalendarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HeatmapCalendar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activity heatmap (17 weeks)',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
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
          ],
        ),
      ),
    );
  }
}
