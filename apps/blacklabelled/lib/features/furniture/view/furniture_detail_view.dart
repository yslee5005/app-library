import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../providers/data_providers.dart';
import '../../../theme/blacklabelled_theme.dart';

class FurnitureDetailView extends ConsumerStatefulWidget {
  final String id;

  const FurnitureDetailView({super.key, required this.id});

  @override
  ConsumerState<FurnitureDetailView> createState() =>
      _FurnitureDetailViewState();
}

class _FurnitureDetailViewState extends ConsumerState<FurnitureDetailView> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _toggleScrap() async {
    await ref.read(scrapRepositoryProvider).toggle('furniture', widget.id);
    ref.invalidate(isScrappedProvider);
    ref.invalidate(scrapsProvider);
  }

  Future<void> _launchPhone() async {
    final uri = Uri.parse('tel:010-9887-2826');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchKakao() async {
    final uri = Uri.parse('https://pf.kakao.com/_blacklabelled');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final furnitureAsync = ref.watch(furnitureByIdProvider(widget.id));
    final isScrappedAsync = ref.watch(
      isScrappedProvider((contentType: 'furniture', contentId: widget.id)),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isScrappedAsync.valueOrNull == true
                  ? Icons.favorite
                  : Icons.favorite_border,
              color:
                  isScrappedAsync.valueOrNull == true
                      ? Colors.red
                      : theme.colorScheme.primary,
            ),
            onPressed: _toggleScrap,
          ),
        ],
      ),
      body: furnitureAsync.when(
        data: (furniture) {
          if (furniture == null) {
            return const Center(child: Text('Furniture not found'));
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
                      itemCount: furniture.images.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: furniture.images[index],
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
                    if (furniture.images.length > 1)
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: furniture.images.length,
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

              // Furniture Info
              Padding(
                padding: const EdgeInsets.all(
                  BlackLabelledSpacing.contentPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(furniture.title, style: theme.textTheme.headlineLarge),
                    const SizedBox(height: 4),
                    Text(
                      furniture.category,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: BlackLabelledSpacing.lg),
                    Divider(color: theme.colorScheme.outline, thickness: 0.5),
                    const SizedBox(height: BlackLabelledSpacing.lg),
                    Text(
                      furniture.description,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.8),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: BlackLabelledSpacing.xl),

              // Contact Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: BlackLabelledSpacing.contentPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INQUIRY',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3.0,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: BlackLabelledSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _launchPhone,
                        icon: const Icon(Icons.phone_outlined, size: 18),
                        label: const Text('CALL'),
                      ),
                    ),
                    const SizedBox(height: BlackLabelledSpacing.sm),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _launchKakao,
                        icon: const Icon(Icons.chat_outlined, size: 18),
                        label: const Text('KAKAOTALK'),
                      ),
                    ),
                  ],
                ),
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
}
