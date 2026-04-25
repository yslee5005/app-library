import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class SortSelectorDemo extends StatefulWidget {
  const SortSelectorDemo({super.key});

  @override
  State<SortSelectorDemo> createState() => _SortSelectorDemoState();
}

class _SortSelectorDemoState extends State<SortSelectorDemo> {
  String _selected = 'newest';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SortSelector')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SortSelector(
              options: const [
                SortOption(
                  id: 'newest',
                  label: 'Newest',
                  icon: Icons.access_time,
                ),
                SortOption(
                  id: 'popular',
                  label: 'Popular',
                  icon: Icons.trending_up,
                ),
                SortOption(
                  id: 'name',
                  label: 'Name',
                  icon: Icons.sort_by_alpha,
                ),
              ],
              selected: _selected,
              onSortChanged: (opt) => setState(() => _selected = opt.id),
            ),
            const SizedBox(height: 16),
            Text(
              'Selected: $_selected',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
