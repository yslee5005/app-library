import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../providers/data_providers.dart';
import '../../../theme/blacklabelled_theme.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featuredAsync = ref.watch(featuredProjectsProvider);
    final allProjectsAsync = ref.watch(allProjectsProvider);
    final furnitureAsync = ref.watch(allFurnitureProvider);
    final magazinesAsync = ref.watch(magazinesProvider);

    return ListView(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      children: [
        // Hero Section — full-screen branding with parallax
        _HeroSection(
          featuredAsync: featuredAsync,
          scrollOffset: _scrollOffset,
        ),

        // Selected Works — Bento grid with scroll reveal
        const SizedBox(height: BlackLabelledSpacing.sectionSpacing),
        _SectionHeader(title: 'Selected Works')
            .animate()
            .fadeIn(duration: 600.ms, curve: Curves.easeOut)
            .slideY(begin: 0.1, end: 0, duration: 600.ms),
        const SizedBox(height: BlackLabelledSpacing.lg),
        allProjectsAsync.when(
          data: (projects) => _BentoGrid(projects: projects),
          loading: () => const SizedBox(
            height: 400,
            child: Center(
              child: CircularProgressIndicator(color: Colors.white24),
            ),
          ),
          error: (_, __) => const SizedBox(height: 400),
        ),

        // Philosophy Statement
        const SizedBox(height: BlackLabelledSpacing.sectionSpacing),
        _PhilosophySection()
            .animate()
            .fadeIn(duration: 800.ms, curve: Curves.easeOut)
            .slideY(begin: 0.05, end: 0, duration: 800.ms),

        // Curated Items — horizontal furniture scroll
        const SizedBox(height: BlackLabelledSpacing.sectionSpacing),
        _SectionHeader(title: 'Curated Items', trailing: '전체보기')
            .animate()
            .fadeIn(duration: 600.ms, curve: Curves.easeOut),
        const SizedBox(height: BlackLabelledSpacing.lg),
        furnitureAsync.when(
          data: (items) => _CuratedItems(items: items),
          loading: () => const SizedBox(
            height: 300,
            child: Center(
              child: CircularProgressIndicator(color: Colors.white24),
            ),
          ),
          error: (_, __) => const SizedBox(height: 300),
        ),

        // Journal
        const SizedBox(height: BlackLabelledSpacing.sectionSpacing),
        _SectionHeader(title: 'Journal')
            .animate()
            .fadeIn(duration: 600.ms, curve: Curves.easeOut),
        const SizedBox(height: BlackLabelledSpacing.lg),
        magazinesAsync.when(
          data: (magazines) => _JournalSection(magazines: magazines),
          loading: () => const SizedBox(height: 200),
          error: (_, __) => const SizedBox.shrink(),
        ),

        // Footer
        const SizedBox(height: BlackLabelledSpacing.xxxl),
        _Footer(),
        const SizedBox(height: BlackLabelledSpacing.xxl),
      ],
    );
  }
}

// ─── Hero Section — Cinematic Ken Burns Slideshow ────────────

class _HeroSection extends StatefulWidget {
  final AsyncValue<List<dynamic>> featuredAsync;
  final double scrollOffset;

  const _HeroSection({
    required this.featuredAsync,
    required this.scrollOffset,
  });

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _zoomController;
  late AnimationController _fadeController;
  int _currentIndex = 0;
  int _nextIndex = 1;
  List<String> _imageUrls = [];

  // Zoom origins alternate per image for visual variety
  static const _zoomAlignments = [
    Alignment.center,
    Alignment(-0.3, -0.3), // top-left drift
    Alignment(0.3, 0.3), // bottom-right drift
    Alignment(0.2, -0.2), // top-right drift
    Alignment(-0.2, 0.2), // bottom-left drift
  ];

  @override
  void initState() {
    super.initState();

    // Zoom: 4 seconds per image (1.0 -> 1.10)
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // Crossfade: 1 second
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _zoomController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _transitionToNext();
      }
    });
  }

  @override
  void didUpdateWidget(covariant _HeroSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _tryStartAnimation();
  }

  void _tryStartAnimation() {
    final urls = _extractImageUrls();
    if (urls.isNotEmpty && _imageUrls.isEmpty) {
      _imageUrls = urls;
      _currentIndex = 0;
      _nextIndex = urls.length > 1 ? 1 : 0;
      _zoomController.forward(from: 0);
    }
  }

  List<String> _extractImageUrls() {
    return widget.featuredAsync.whenOrNull(
          data: (projects) => projects
              .where((p) => (p.images as List).isNotEmpty)
              .map((p) => p.images[0] as String)
              .toList(),
        ) ??
        [];
  }

  void _transitionToNext() {
    if (_imageUrls.length <= 1) {
      // Single image: just restart zoom
      _zoomController.forward(from: 0);
      return;
    }

    // Start crossfade to next image
    _fadeController.forward(from: 0).then((_) {
      if (!mounted) return;
      setState(() {
        _currentIndex = _nextIndex;
        _nextIndex = (_nextIndex + 1) % _imageUrls.length;
      });
      _fadeController.reset();
      _zoomController.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Try to start on first build with data
    if (_imageUrls.isEmpty) _tryStartAnimation();

    final height = MediaQuery.of(context).size.height * 0.85;
    final heroOpacity =
        (1.0 - (widget.scrollOffset / (height * 0.8))).clamp(0.0, 1.0);
    // Parallax on scroll
    final parallaxOffset = widget.scrollOffset * 0.3;

    return SizedBox(
      height: height,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Black base (prevents white flash during crossfade)
            Container(color: Colors.black),

            // Current image with Ken Burns zoom
            if (_imageUrls.isNotEmpty)
              AnimatedBuilder(
                animation: _zoomController,
                builder: (context, child) {
                  final scale = 1.0 + (_zoomController.value * 0.10);
                  final alignment = _zoomAlignments[
                      _currentIndex % _zoomAlignments.length];
                  return Transform(
                    alignment: alignment,
                    transform: Matrix4.identity()
                      ..translate(0.0, -parallaxOffset)
                      ..scale(scale),
                    child: child,
                  );
                },
                child: CachedNetworkImage(
                  key: ValueKey('hero-$_currentIndex'),
                  imageUrl: _imageUrls[_currentIndex],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (_, __) =>
                      Container(color: BlackLabelledColors.surface),
                  errorWidget: (_, __, ___) =>
                      Container(color: BlackLabelledColors.surface),
                ),
              ),

            // Next image fading in during crossfade
            if (_imageUrls.length > 1)
              AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  if (_fadeController.value == 0) {
                    return const SizedBox.shrink();
                  }
                  return Opacity(
                    opacity: Curves.easeInOut.transform(_fadeController.value),
                    child: Transform(
                      alignment: _zoomAlignments[
                          _nextIndex % _zoomAlignments.length],
                      transform: Matrix4.identity()
                        ..translate(0.0, -parallaxOffset)
                        ..scale(1.0), // next image starts at 1.0
                      child: child,
                    ),
                  );
                },
                child: CachedNetworkImage(
                  key: ValueKey('hero-next-$_nextIndex'),
                  imageUrl: _imageUrls.isNotEmpty
                      ? _imageUrls[_nextIndex % _imageUrls.length]
                      : '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),

            // Content with fade on scroll
            Positioned(
              left: BlackLabelledSpacing.contentPadding,
              right: BlackLabelledSpacing.contentPadding,
              bottom: 80,
              child: Opacity(
                opacity: heroOpacity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Seoul / Bundang',
                      style: GoogleFonts.openSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4.0,
                        color: BlackLabelledColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'BLACKLABELLED\nDESIGN STUDIO',
                      style: GoogleFonts.montserrat(
                        fontSize: 32,
                        fontWeight: FontWeight.w200,
                        fontStyle: FontStyle.italic,
                        letterSpacing: -1.0,
                        color: Colors.white,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 280,
                      child: Text(
                        '우리는 단순한 인테리어를 넘어, 건축적 미학과 극도의 절제미를 담은 공간의 본질을 설계합니다.',
                        style: GoogleFonts.notoSansKr(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: BlackLabelledColors.textSecondary
                              .withValues(alpha: 0.8),
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section Header ──────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;

  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: BlackLabelledSpacing.contentPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.openSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 3.0,
              color: BlackLabelledColors.textMuted,
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: GoogleFonts.notoSansKr(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: BlackLabelledColors.textMuted,
                decoration: TextDecoration.underline,
                decorationColor: BlackLabelledColors.textMuted,
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Bento Grid with Scroll Reveal ───────────────────────────

class _BentoGrid extends StatelessWidget {
  final List<dynamic> projects;

  const _BentoGrid({required this.projects});

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: BlackLabelledSpacing.contentPadding,
      ),
      child: Column(
        children: [
          // Large featured image (4:5, full width) — fade + scale reveal
          _BentoItem(project: projects[0], aspectRatio: 4 / 5)
              .animate()
              .fadeIn(duration: 700.ms, curve: Curves.easeOut)
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1.0, 1.0),
                duration: 700.ms,
                curve: Curves.easeOut,
              ),
          const SizedBox(height: BlackLabelledSpacing.md),
          // Two smaller images — staggered reveal
          if (projects.length >= 3)
            Row(
              children: [
                Expanded(
                  child: _BentoItem(project: projects[1], aspectRatio: 1)
                      .animate()
                      .fadeIn(
                        delay: 200.ms,
                        duration: 600.ms,
                        curve: Curves.easeOut,
                      )
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1.0, 1.0),
                        delay: 200.ms,
                        duration: 600.ms,
                        curve: Curves.easeOut,
                      ),
                ),
                const SizedBox(width: BlackLabelledSpacing.md),
                Expanded(
                  child: _BentoItem(project: projects[2], aspectRatio: 1)
                      .animate()
                      .fadeIn(
                        delay: 350.ms,
                        duration: 600.ms,
                        curve: Curves.easeOut,
                      )
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1.0, 1.0),
                        delay: 350.ms,
                        duration: 600.ms,
                        curve: Curves.easeOut,
                      ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _BentoItem extends StatelessWidget {
  final dynamic project;
  final double aspectRatio;

  const _BentoItem({required this.project, required this.aspectRatio});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        (project.images as List).isNotEmpty ? project.images[0] as String : '';

    return GestureDetector(
      onTap: () => context.push('/portfolio/${project.id}'),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(color: BlackLabelledColors.surfaceContainer),
              errorWidget: (_, __, ___) => Container(
                color: BlackLabelledColors.surfaceContainer,
                child: const Icon(
                  Icons.image_outlined,
                  size: 32,
                  color: BlackLabelledColors.textMuted,
                ),
              ),
            ),
            // Bottom gradient for text
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                (project.title as String).toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Philosophy Statement ────────────────────────────────────

class _PhilosophySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: BlackLabelledSpacing.contentPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"공백은 채우기 위한 공간이 아니라,\n존재 그 자체로 호흡하는\n건축적 장치입니다."',
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
              color: BlackLabelledColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: BlackLabelledSpacing.xl),
          ElevatedButton(
            onPressed: () => context.go('/consult'),
            child: const Text('상담 신청하기'),
          ),
        ],
      ),
    );
  }
}

// ─── Curated Items with 3D tilt ──────────────────────────────

class _CuratedItems extends StatelessWidget {
  final List<dynamic> items;

  const _CuratedItems({required this.items});

  @override
  Widget build(BuildContext context) {
    final itemCount = items.length > 6 ? 6 : items.length;

    return SizedBox(
      height: 300,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: BlackLabelledSpacing.contentPadding,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (_, __) =>
            const SizedBox(width: BlackLabelledSpacing.lg),
        itemBuilder: (context, index) {
          final item = items[index];
          return _CuratedCard(item: item, index: index);
        },
      ),
    );
  }
}

class _CuratedCard extends StatefulWidget {
  final dynamic item;
  final int index;

  const _CuratedCard({required this.item, required this.index});

  @override
  State<_CuratedCard> createState() => _CuratedCardState();
}

class _CuratedCardState extends State<_CuratedCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final imageUrl = (widget.item.images as List).isNotEmpty
        ? widget.item.images[0] as String
        : '';

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        context.push('/furniture/${widget.item.id}');
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: SizedBox(
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with subtle perspective
              Expanded(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(0.01), // barely perceptible tilt
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: BlackLabelledColors.surfaceContainer,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: BlackLabelledColors.surfaceContainer,
                      child: const Icon(
                        Icons.image_outlined,
                        color: BlackLabelledColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                (widget.item.title as String).toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                widget.item.category as String,
                style: GoogleFonts.openSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: BlackLabelledColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: (100 * widget.index).ms)
        .fadeIn(duration: 500.ms, curve: Curves.easeOut)
        .slideX(
          begin: 0.1,
          end: 0,
          duration: 500.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

// ─── Journal Section ─────────────────────────────────────────

class _JournalSection extends StatelessWidget {
  final List<dynamic> magazines;

  const _JournalSection({required this.magazines});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: BlackLabelledSpacing.contentPadding,
      ),
      child: Column(
        children: magazines.asMap().entries.map((entry) {
          final index = entry.key;
          final m = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: BlackLabelledSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CachedNetworkImage(
                    imageUrl: m.thumbnail as String,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: BlackLabelledColors.surfaceContainer,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: BlackLabelledColors.surfaceContainer,
                      child: const Icon(
                        Icons.article_outlined,
                        color: BlackLabelledColors.textMuted,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: BlackLabelledSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.title as String,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: BlackLabelledColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        m.summary as String,
                        style: GoogleFonts.notoSansKr(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: BlackLabelledColors.textSecondary,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        m.date as String,
                        style: GoogleFonts.openSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: BlackLabelledColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              .animate(delay: (150 * index).ms)
              .fadeIn(duration: 500.ms, curve: Curves.easeOut)
              .slideY(begin: 0.05, end: 0, duration: 500.ms);
        }).toList(),
      ),
    );
  }
}

// ─── Footer ──────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: BlackLabelledSpacing.contentPadding,
      ),
      child: Column(
        children: [
          Container(height: 0.5, color: BlackLabelledColors.borderSubtle),
          const SizedBox(height: BlackLabelledSpacing.xl),
          Text(
            'BlackLabelled',
            style: GoogleFonts.epilogue(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
              letterSpacing: -0.5,
              color: BlackLabelledColors.textMuted,
            ),
          ),
          const SizedBox(height: BlackLabelledSpacing.sm),
          Text(
            '경기도 성남시 분당구 야탑로 81\nTel. 010-9887-2826',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKr(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: BlackLabelledColors.textMuted,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'blacklabelled@naver.com',
            style: GoogleFonts.openSans(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: BlackLabelledColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
