import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class SearchDemo extends StatefulWidget {
  const SearchDemo({super.key});

  @override
  State<SearchDemo> createState() => _SearchDemoState();
}

class _SearchDemoState extends State<SearchDemo> {
  Set<String> _selectedChips = {'All'};
  String _selectedSort = 'newest';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(context, 'AppSearchBar'),
          AppSearchBar(
            hint: 'Search components...',
            onChanged: (q) => setState(() => _searchQuery = q),
            onSubmitted: (q) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Searched: $q')),
              );
            },
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Query: $_searchQuery',
                style: Theme.of(context).textTheme.bodySmall),
          ],
          const SizedBox(height: 24),
          _sectionTitle(context, 'ChipFilterBar'),
          ChipFilterBar(
            options: const [
              'All',
              'Navigation',
              'Forms',
              'Feedback',
              'Media',
            ],
            selected: _selectedChips,
            onSelectionChanged: (s) => setState(() => _selectedChips = s),
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'SortSelector'),
          SortSelector(
            options: const [
              SortOption(id: 'newest', label: 'Newest', icon: Icons.access_time),
              SortOption(id: 'popular', label: 'Popular', icon: Icons.trending_up),
              SortOption(id: 'name', label: 'Name', icon: Icons.sort_by_alpha),
            ],
            selected: _selectedSort,
            onSortChanged: (opt) =>
                setState(() => _selectedSort = opt.id),
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'FilterBottomSheet'),
          ElevatedButton.icon(
            icon: const Icon(Icons.filter_list),
            label: const Text('Open Filters'),
            onPressed: () {
              FilterBottomSheet.show(
                context,
                sections: [
                  FilterSection(
                    id: 'category',
                    title: 'Category',
                    options: const [
                      'Navigation',
                      'Forms',
                      'Feedback',
                      'Media',
                    ],
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
                      content:
                          Text('Filters applied: ${state.selected.length} sections'),
                    ),
                  );
                },
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
