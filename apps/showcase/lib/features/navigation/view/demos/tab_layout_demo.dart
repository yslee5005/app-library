import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class TabLayoutDemo extends StatelessWidget {
  const TabLayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppTabLayout')),
      body: AppTabLayout(
        tabs: [
          AppTab(
            label: 'Recent',
            icon: Icons.access_time,
            body: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, i) => ListTile(
                title: Text('Recent item ${i + 1}'),
              ),
            ),
          ),
          AppTab(
            label: 'Favorites',
            icon: Icons.favorite,
            body: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, i) => ListTile(
                leading: const Icon(Icons.star, color: Colors.amber),
                title: Text('Favorite ${i + 1}'),
              ),
            ),
          ),
          AppTab(
            label: 'Saved',
            icon: Icons.bookmark,
            body: const Center(child: Text('No saved items yet')),
          ),
        ],
      ),
    );
  }
}
