import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class FilterBottomSheetDemo extends StatelessWidget {
  const FilterBottomSheetDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FilterBottomSheet')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.filter_list),
          label: const Text('Open Filters'),
          onPressed: () {
            FilterBottomSheet.show(
              context,
              sections: [
                FilterSection(
                  id: 'category',
                  title: 'Category',
                  options: const ['Navigation', 'Forms', 'Feedback', 'Media'],
                ),
                FilterSection(
                  id: 'rating',
                  title: 'Rating',
                  range: const RangeValues(0, 5),
                ),
              ],
              onApply: (state) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Filters applied: ${state.selected.length} sections',
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
