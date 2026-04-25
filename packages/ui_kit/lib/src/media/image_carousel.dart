import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// A [PageView] of images with page indicator dots and optional auto-play.
class ImageCarousel extends StatefulWidget {
  const ImageCarousel({
    required this.imageUrls,
    this.height = 250,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.onPageChanged,
    this.placeholder,
    this.indicatorColor,
    this.indicatorBuilder,
    super.key,
  });

  /// List of image URLs to display.
  final List<String> imageUrls;

  /// Height of the carousel.
  final double height;

  /// Whether to auto-advance pages.
  final bool autoPlay;

  /// Interval between auto-advance.
  final Duration autoPlayInterval;

  /// Border radius for the carousel container.
  final BorderRadius? borderRadius;

  /// How images are inscribed.
  final BoxFit fit;

  /// Called with the new page index when the page changes.
  final ValueChanged<int>? onPageChanged;

  /// Widget shown while each image loads.
  final Widget? placeholder;

  /// Optional color for the active page indicator dot.
  final Color? indicatorColor;

  /// Custom indicator widget builder.
  /// Receives the total page count and current page index.
  /// When provided, replaces the default dot indicators.
  final Widget Function(int pageCount, int currentPage)? indicatorBuilder;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.autoPlay && widget.imageUrls.length > 1) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    Future.delayed(widget.autoPlayInterval, () {
      if (!mounted) return;
      final next = (_currentPage + 1) % widget.imageUrls.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      _startAutoPlay();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = widget.borderRadius ?? BorderRadius.circular(AppRadius.lg);

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: radius,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
                widget.onPageChanged?.call(index);
              },
              itemBuilder: (context, index) {
                return Image.network(
                  widget.imageUrls[index],
                  fit: widget.fit,
                  width: double.infinity,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return widget.placeholder ??
                        Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        );
                  },
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
          ),

          // Page indicator
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
                        children: List.generate(widget.imageUrls.length, (
                          index,
                        ) {
                          final isActive = index == _currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: isActive ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color:
                                  isActive
                                      ? (widget.indicatorColor ??
                                          theme.colorScheme.primary)
                                      : theme.colorScheme.onSurface.withAlpha(
                                        80,
                                      ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
            ),
        ],
      ),
    );
  }
}
