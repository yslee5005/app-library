import 'package:flutter/material.dart';

import 'demos/chip_filter_bar_demo.dart';
import 'demos/filter_bottom_sheet_demo.dart';
import 'demos/search_bar_demo.dart';
import 'demos/sort_selector_demo.dart';

class SearchDemo extends StatelessWidget {
  const SearchDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('AppSearchBar'),
            subtitle: const Text('Search bar with debounced input'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const SearchBarDemo()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.filter_list),
            title: const Text('FilterBottomSheet'),
            subtitle: const Text('Bottom sheet with filter options'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const FilterBottomSheetDemo(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.sort),
            title: const Text('SortSelector'),
            subtitle: const Text('Sort dropdown with icons'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const SortSelectorDemo()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.filter_alt),
            title: const Text('ChipFilterBar'),
            subtitle: const Text('Horizontal scrollable chip filters'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const ChipFilterBarDemo()),
            ),
          ),
        ],
      ),
    );
  }
}
