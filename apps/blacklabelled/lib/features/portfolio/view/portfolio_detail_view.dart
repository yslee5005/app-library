import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../providers/data_providers.dart';
import '../../../theme/blacklabelled_theme.dart';

class PortfolioDetailView extends ConsumerStatefulWidget {
  final String id;

  const PortfolioDetailView({super.key, required this.id});

  @override
  ConsumerState<PortfolioDetailView> createState() =>
      _PortfolioDetailViewState();
}

class _PortfolioDetailViewState extends ConsumerState<PortfolioDetailView> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectAsync = ref.watch(projectByIdProvider(widget.id));
    final allProjectsAsync = ref.watch(allProjectsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: projectAsync.when(
        data: (project) {
          if (project == null) {
            return const Center(child: Text('Project not found'));
          }
          return ListView(
            children: [
              // Image Gallery
              SizedBox(
                height: 320,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: project.images.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: project.images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder:
                              (_, __) =>
                                  Container(color: theme.colorScheme.surface),
                          errorWidget:
                              (_, __, ___) => Container(
                                color: theme.colorScheme.surface,
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 48,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                        );
                      },
                    ),
                    if (project.images.length > 1)
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: project.images.length,
                            effect: WormEffect(
                              dotHeight: 6,
                              dotWidth: 6,
                              spacing: 8,
                              activeDotColor: theme.colorScheme.primary,
                              dotColor: theme.colorScheme.secondary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Project Info
              Padding(
                padding: const EdgeInsets.all(
                  BlackLabelledSpacing.contentPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.title, style: theme.textTheme.headlineLarge),
                    const SizedBox(height: 4),
                    Text(
                      project.location,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (project.area != null) ...[
                          Text(
                            project.area!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                          _dot(theme),
                        ],
                        if (project.year != null) ...[
                          Text(
                            project.year!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                          _dot(theme),
                        ],
                        Text(
                          project.category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: BlackLabelledSpacing.lg),
                    Divider(color: theme.colorScheme.outline, thickness: 0.5),
                    const SizedBox(height: BlackLabelledSpacing.lg),
                    Text(
                      project.description,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.8),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: BlackLabelledSpacing.sectionSpacing),

              // Related Projects
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: BlackLabelledSpacing.contentPadding,
                ),
                child: Text(
                  'RELATED PROJECTS',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3.0,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: BlackLabelledSpacing.md),
              allProjectsAsync.when(
                data: (projects) {
                  final related =
                      projects
                          .where(
                            (p) =>
                                p.category == project.category &&
                                p.id != project.id,
                          )
                          .take(4)
                          .toList();
                  if (related.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return SizedBox(
                    height: 200,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: BlackLabelledSpacing.contentPadding,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: related.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final p = related[index];
                        return GestureDetector(
                          onTap: () => context.push('/portfolio/${p.id}'),
                          child: SizedBox(
                            width: 160,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        p.images.isNotEmpty ? p.images[0] : '',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    placeholder:
                                        (_, __) => Container(
                                          color: theme.colorScheme.surface,
                                        ),
                                    errorWidget:
                                        (_, __, ___) => Container(
                                          color: theme.colorScheme.surface,
                                          child: Icon(
                                            Icons.image_outlined,
                                            color: theme.colorScheme.secondary,
                                          ),
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  p.title,
                                  style: theme.textTheme.titleSmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  p.location,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: BlackLabelledSpacing.sectionSpacing),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _dot(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '\u00B7',
        style: TextStyle(color: theme.colorScheme.secondary),
      ),
    );
  }
}
