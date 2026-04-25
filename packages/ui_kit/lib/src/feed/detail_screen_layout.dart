import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// Detail screen with SliverAppBar hero image, scrollable body, and
/// optional bottom action bar.
///
/// Supports both single hero image and multi-image gallery via [heroImages].
class DetailScreenLayout extends StatelessWidget {
  const DetailScreenLayout({
    required this.body,
    this.heroImage,
    this.heroImages,
    this.title,
    this.expandedHeight = 300.0,
    this.bottomBar,
    this.actions,
    this.bodyPadding,
    this.indicatorBuilder,
    super.key,
  });

  /// The scrollable body content.
  final Widget body;

  /// Single hero image shown in the SliverAppBar.
  final Widget? heroImage;

  /// Multiple hero image URLs for a swipeable gallery.
  /// When provided, takes precedence over [heroImage].
  final List<String>? heroImages;

  /// Title shown in the app bar when collapsed.
  final String? title;

  /// Height of the expanded SliverAppBar.
  final double expandedHeight;

  /// Optional bottom action bar (e.g. a button row).
  final Widget? bottomBar;

  /// Optional app bar actions.
  final List<Widget>? actions;

  /// Optional body content padding override.
  final EdgeInsetsGeometry? bodyPadding;

  /// Custom indicator builder for multi-image gallery.
  final Widget Function(int pageCount, int currentPage)? indicatorBuilder;

  @override
  Widget build(BuildContext context) {
    final hasGallery = heroImages != null && heroImages!.isNotEmpty;
    final hasHero = heroImage != null || hasGallery;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: hasHero ? expandedHeight : null,
            pinned: true,
            title: title != null ? Text(title!) : null,
            actions: actions,
            flexibleSpace:
                hasHero
                    ? FlexibleSpaceBar(
                      background:
                          hasGallery
                              ? _HeroGallery(
                                imageUrls: heroImages!,
                                indicatorBuilder: indicatorBuilder,
                              )
                              : heroImage,
                    )
                    : null,
          ),
          SliverPadding(
            padding: bodyPadding ?? const EdgeInsets.all(AppSpacing.md),
            sliver: SliverToBoxAdapter(child: body),
          ),
        ],
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}

class _HeroGallery extends StatefulWidget {
  const _HeroGallery({required this.imageUrls, this.indicatorBuilder});

  final List<String> imageUrls;
  final Widget Function(int pageCount, int currentPage)? indicatorBuilder;

  @override
  State<_HeroGallery> createState() => _HeroGalleryState();
}

class _HeroGalleryState extends State<_HeroGallery> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          itemCount: widget.imageUrls.length,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemBuilder: (context, index) {
            return Image.network(
              widget.imageUrls[index],
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
            );
          },
        ),
        if (widget.imageUrls.length > 1)
          Positioned(
            bottom: AppSpacing.sm,
            left: 0,
            right: 0,
            child:
                widget.indicatorBuilder != null
                    ? Center(
                      child: widget.indicatorBuilder!(
                        widget.imageUrls.length,
                        _currentPage,
                      ),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(widget.imageUrls.length, (index) {
                        final isActive = index == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: isActive ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                isActive
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface.withAlpha(80),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
          ),
      ],
    );
  }
}
