import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class ChipFilterBarDemo extends StatefulWidget {
  const ChipFilterBarDemo({super.key});

  @override
  State<ChipFilterBarDemo> createState() => _ChipFilterBarDemoState();
}

class _ChipFilterBarDemoState extends State<ChipFilterBarDemo> {
  Set<String> _selected = {'All'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChipFilterBar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChipFilterBar(
              options: const [
                'All',
                'Navigation',
                'Forms',
                'Feedback',
                'Media',
                'Charts',
              ],
              selected: _selected,
              onSelectionChanged: (s) => setState(() => _selected = s),
            ),
            const SizedBox(height: 16),
            Text(
              'Selected: ${_selected.join(', ')}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
