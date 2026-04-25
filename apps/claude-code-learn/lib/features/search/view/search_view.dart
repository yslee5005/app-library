import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/content_catalog.dart';
import '../../../providers/providers.dart';
import '../../../services/search_service.dart';
import '../../../theme/learn_theme.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final _controller = TextEditingController();
  List<SearchResult> _results = [];
  bool _indexBuilt = false;
  bool _isBuilding = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _ensureIndex() async {
    if (_indexBuilt || _isBuilding) return;
    _isBuilding = true;
    final searchService = ref.read(searchServiceProvider);
    await searchService.buildIndex();
    _indexBuilt = true;
    _isBuilding = false;
  }

  void _onSearch(String query) async {
    await _ensureIndex();
    final searchService = ref.read(searchServiceProvider);
    final results = searchService.search(query);
    if (mounted) setState(() => _results = results);
  }

  @override
  Widget build(BuildContext context) {
    // Group results by section
    final grouped = <String, List<SearchResult>>{};
    for (final r in _results) {
      final label = ContentCatalog.sectionLabel(r.item.section);
      grouped.putIfAbsent(label, () => []).add(r);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Search', style: LearnTypography.h1)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search articles...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _results = []);
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _results.isEmpty
                ? Center(
                    child: Text(
                      _controller.text.isEmpty
                          ? 'Type to search all articles'
                          : 'No results found',
                      style: LearnTypography.body.copyWith(
                        color: LearnColors.muted,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: grouped.length,
                    itemBuilder: (context, sectionIndex) {
                      final sectionLabel = grouped.keys.elementAt(sectionIndex);
                      final sectionResults = grouped[sectionLabel]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              sectionLabel,
                              style: LearnTypography.label.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          ...sectionResults.map(
                            (r) => Card(
                              clipBehavior: Clip.antiAlias,
                              child: ListTile(
                                title: Text(
                                  r.item.title,
                                  style: LearnTypography.body,
                                ),
                                subtitle: Text(
                                  r.snippet,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: LearnTypography.caption,
                                ),
                                onTap: () => context.go('/read/${r.item.id}'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
