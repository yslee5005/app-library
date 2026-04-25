import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class AppListTileDemo extends StatelessWidget {
  const AppListTileDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppListTile')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, i) {
          return AppListTile(
            title: 'List item ${i + 1}',
            subtitle: 'Subtitle for item ${i + 1}',
            leading: CircleAvatar(child: Text('${i + 1}')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Tapped item ${i + 1}')));
            },
          );
        },
      ),
    );
  }
}
