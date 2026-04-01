import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app.dart';
import '../../../sample_data/sample_data.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const _routes = [
    '/navigation',
    '/onboarding',
    '/profile',
    '/feed',
    '/search',
    '/forms',
    '/feedback',
    '/media',
    '/charts',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Showcase'),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ShowcaseApp.themeMode,
            builder: (context, mode, _) {
              return IconButton(
                icon: Icon(
                  mode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  ShowcaseApp.themeMode.value = mode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: GridView.builder(
          itemCount: SampleData.categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final cat = SampleData.categories[index];
            return _CategoryCard(
              name: cat['name'] as String,
              icon: cat['icon'] as IconData,
              count: cat['count'] as int,
              onTap: () => context.push(_routes[index]),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.count,
    required this.onTap,
  });

  final String name;
  final IconData icon;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: colors.primary),
              const SizedBox(height: AppSpacing.xs),
              Text(
                name,
                style: textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                '$count widgets',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
