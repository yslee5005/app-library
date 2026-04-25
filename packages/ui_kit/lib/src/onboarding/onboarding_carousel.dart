import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// A single page in [OnboardingCarousel].
class OnboardingPage {
  const OnboardingPage({
    required this.title,
    required this.subtitle,
    this.image,
  });

  /// Optional image widget (e.g. Image.asset, SvgPicture).
  final Widget? image;

  /// Page title.
  final String title;

  /// Page subtitle / description.
  final String subtitle;
}

/// PageView with page indicator, skip and next buttons.
///
/// Ideal for first-run onboarding flows.
class OnboardingCarousel extends StatefulWidget {
  const OnboardingCarousel({
    required this.pages,
    required this.onFinish,
    this.onSkip,
    this.skipLabel = 'Skip',
    this.nextLabel = 'Next',
    this.finishLabel = 'Get Started',
    this.indicatorActiveColor,
    this.indicatorInactiveColor,
    this.pageSpacing,
    super.key,
  });

  /// The onboarding pages.
  final List<OnboardingPage> pages;

  /// Called when the user finishes the onboarding (taps finish on last page).
  final VoidCallback onFinish;

  /// Called when the user taps skip. If null, skip button is hidden.
  final VoidCallback? onSkip;

  /// Label for the skip button.
  final String skipLabel;

  /// Label for the next button.
  final String nextLabel;

  /// Label for the finish button on the last page.
  final String finishLabel;

  /// Optional color for the active page indicator.
  final Color? indicatorActiveColor;

  /// Optional color for the inactive page indicator.
  final Color? indicatorInactiveColor;

  /// Optional horizontal spacing for page content.
  final double? pageSpacing;

  @override
  State<OnboardingCarousel> createState() => _OnboardingCarouselState();
}

class _OnboardingCarouselState extends State<OnboardingCarousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  bool get _isLastPage => _currentPage == widget.pages.length - 1;

  void _next() {
    if (_isLastPage) {
      widget.onFinish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Skip button row
        if (widget.onSkip != null)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: TextButton(
                onPressed: widget.onSkip,
                child: Text(widget.skipLabel),
              ),
            ),
          ),

        // PageView
        Expanded(
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: widget.pages.length,
            itemBuilder: (context, index) {
              final page = widget.pages[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.pageSpacing ?? AppSpacing.lg,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (page.image != null) ...[
                      Expanded(flex: 3, child: page.image!),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    Text(
                      page.title,
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      page.subtitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (page.image == null) const Spacer(),
                  ],
                ),
              );
            },
          ),
        ),

        // Page indicator
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.pages.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                width: isActive ? 24.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color:
                      isActive
                          ? (widget.indicatorActiveColor ?? colorScheme.primary)
                          : (widget.indicatorInactiveColor ??
                              colorScheme.outlineVariant),
                  borderRadius: AppRadius.smAll,
                ),
              );
            }),
          ),
        ),

        // Next / Finish button
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _next,
              child: Text(_isLastPage ? widget.finishLabel : widget.nextLabel),
            ),
          ),
        ),
      ],
    );
  }
}
