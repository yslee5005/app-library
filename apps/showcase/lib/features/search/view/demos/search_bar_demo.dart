import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class SearchBarDemo extends StatefulWidget {
  const SearchBarDemo({super.key});

  @override
  State<SearchBarDemo> createState() => _SearchBarDemoState();
}

class _SearchBarDemoState extends State<SearchBarDemo> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppSearchBar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSearchBar(
              hint: 'Search components...',
              onChanged: (q) => setState(() => _query = q),
              onSubmitted: (q) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Searched: $q')),
                );
              },
            ),
            const SizedBox(height: 16),
            if (_query.isNotEmpty)
              Text('Query: $_query',
                  style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
