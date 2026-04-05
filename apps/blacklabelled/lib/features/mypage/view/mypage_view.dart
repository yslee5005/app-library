import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/scrap.dart';
import '../../../providers/data_providers.dart';
import '../../../theme/blacklabelled_theme.dart';

class MyPageView extends ConsumerWidget {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scrapsAsync = ref.watch(scrapsProvider);

    return ListView(
      padding: const EdgeInsets.all(BlackLabelledSpacing.contentPadding),
      children: [
        const SizedBox(height: BlackLabelledSpacing.md),

        // Scrapbook Section
        Text(
          'MY SCRAPBOOK',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.0,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: BlackLabelledSpacing.lg),

        scrapsAsync.when(
          data: (scraps) {
            final projectScraps =
                scraps.where((s) => s.contentType == 'project').toList();
            final furnitureScraps =
                scraps.where((s) => s.contentType == 'furniture').toList();

            return Column(
              children: [
                _ScrapSection(
                  title: 'Projects (${projectScraps.length})',
                  scraps: projectScraps,
                  routePrefix: '/portfolio',
                ),
                const SizedBox(height: BlackLabelledSpacing.md),
                _ScrapSection(
                  title: 'Furniture (${furnitureScraps.length})',
                  scraps: furnitureScraps,
                  routePrefix: '/furniture',
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (_, __) => Text(
                'Failed to load scraps',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
        ),

        const SizedBox(height: BlackLabelledSpacing.sectionSpacing),

        // Settings Section
        Text(
          'SETTINGS',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.0,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: BlackLabelledSpacing.lg),

        // App Version
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: BlackLabelledSpacing.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('App Version', style: theme.textTheme.bodyMedium),
              Text(
                '1.0.0',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: BlackLabelledSpacing.sectionSpacing),

        // SNS Section
        Text(
          'SNS',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.0,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: BlackLabelledSpacing.lg),

        _LinkTile(
          title: 'Instagram',
          subtitle: '@blacklabelled_official',
          onTap: () async {
            final uri = Uri.parse(
              'https://www.instagram.com/blacklabelled_official/',
            );
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
        ),
        Divider(color: theme.colorScheme.outline, thickness: 0.5),
        _LinkTile(
          title: 'Naver Blog',
          subtitle: 'BLACKLABELLED',
          onTap: () async {
            final uri = Uri.parse('https://blog.naver.com/blacklabelled');
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
        ),

        const SizedBox(height: BlackLabelledSpacing.sectionSpacing),

        // Company Info
        Text(
          'BLACKLABELLED',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            letterSpacing: 2.0,
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: BlackLabelledSpacing.sm),
        Text(
          '경기도 성남시 분당구 야탑로 81\nTel. 010-9887-2826\nblacklabelled@naver.com',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.secondary,
            height: 1.6,
          ),
        ),

        const SizedBox(height: BlackLabelledSpacing.sectionSpacing),
      ],
    );
  }
}

class _ScrapSection extends ConsumerWidget {
  final String title;
  final List<Scrap> scraps;
  final String routePrefix;

  const _ScrapSection({
    required this.title,
    required this.scraps,
    required this.routePrefix,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: BlackLabelledSpacing.sm),
        if (scraps.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: BlackLabelledSpacing.md,
            ),
            child: Text(
              'No items saved yet',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          )
        else
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: scraps.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final scrap = scraps[index];
                return _ScrapCard(scrap: scrap, routePrefix: routePrefix);
              },
            ),
          ),
      ],
    );
  }
}

class _ScrapCard extends ConsumerWidget {
  final Scrap scrap;
  final String routePrefix;

  const _ScrapCard({required this.scrap, required this.routePrefix});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Get the item details based on type
    String title = '';
    String imageUrl = '';

    if (scrap.contentType == 'project') {
      final projectAsync = ref.watch(projectByIdProvider(scrap.contentId));
      projectAsync.whenData((project) {
        if (project != null) {
          title = project.title;
          imageUrl = project.images.isNotEmpty ? project.images[0] : '';
        }
      });
    } else {
      final furnitureAsync = ref.watch(furnitureByIdProvider(scrap.contentId));
      furnitureAsync.whenData((furniture) {
        if (furniture != null) {
          title = furniture.title;
          imageUrl = furniture.images.isNotEmpty ? furniture.images[0] : '';
        }
      });
    }

    return GestureDetector(
      onTap: () => context.push('$routePrefix/${scrap.contentId}'),
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              width: 120,
              child:
                  imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder:
                            (_, __) =>
                                Container(color: theme.colorScheme.surface),
                        errorWidget:
                            (_, __, ___) => Container(
                              color: theme.colorScheme.surface,
                              child: Icon(
                                Icons.image_outlined,
                                color: theme.colorScheme.secondary,
                                size: 20,
                              ),
                            ),
                      )
                      : Container(
                        color: theme.colorScheme.surface,
                        child: Icon(
                          Icons.image_outlined,
                          color: theme.colorScheme.secondary,
                          size: 20,
                        ),
                      ),
            ),
            const SizedBox(height: 6),
            Text(
              title.isNotEmpty ? title : 'Loading...',
              style: theme.textTheme.labelMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LinkTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: BlackLabelledSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: theme.colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
