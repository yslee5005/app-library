import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:app_lib_logging/logging.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/qt_passage.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_button.dart';
import '../../recording/view/recording_overlay.dart';

class QtView extends ConsumerWidget {
  const QtView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final passagesAsync = ref.watch(qtPassagesProvider);

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        title: Text('${l10n.qtPageTitle} 🌱', style: AbbaTypography.h1),
      ),
      body: passagesAsync.when(
        data: (passages) => _QtRevealContent(
          passages: passages,
          locale: locale,
          l10n: l10n,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text(l10n.errorGeneric)),
      ),
    );
  }
}

class _QtRevealContent extends StatefulWidget {
  final List<QTPassage> passages;
  final String locale;
  final AppLocalizations l10n;

  const _QtRevealContent({
    required this.passages,
    required this.locale,
    required this.l10n,
  });

  @override
  State<_QtRevealContent> createState() => _QtRevealContentState();
}

class _QtRevealContentState extends State<_QtRevealContent>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  int _revealedCount = 0;
  int? _selectedIndex;
  bool _allRevealed = false;
  int _currentPage = 0;

  // Split passages into pages of 5
  List<QTPassage> get _page1 =>
      widget.passages.sublist(0, min(5, widget.passages.length));
  List<QTPassage> get _page2 => widget.passages.length > 5
      ? widget.passages.sublist(5)
      : <QTPassage>[];
  bool get _hasPage2 => _page2.isNotEmpty;
  int get _pageCount => _hasPage2 ? 2 : 1;

  @override
  void initState() {
    super.initState();
    qtLog.info('QT passages loaded: ${widget.passages.length}');
    _pageController = PageController();

    // Only create reveal animations for page 1
    _controllers = List.generate(
      _page1.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );

    _fadeAnimations = _controllers.map((c) {
      return CurvedAnimation(parent: c, curve: Curves.easeOut);
    }).toList();

    _slideAnimations = _controllers.map((c) {
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: c, curve: Curves.easeOut));
    }).toList();

    _startReveal();
  }

  Future<void> _startReveal() async {
    for (int i = 0; i < _page1.length; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      _controllers[i].forward();
      setState(() => _revealedCount = i + 1);
    }

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) setState(() => _allRevealed = true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _selectCard(int globalIndex) {
    setState(() {
      _selectedIndex = _selectedIndex == globalIndex ? null : globalIndex;
    });
    if (_selectedIndex == globalIndex) {
      final passage = widget.passages[globalIndex];
      qtLog.info('QT passage selected: ${passage.reference}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat.yMMMMd(widget.locale).format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.lg),
          child: Text(
            today,
            style: AbbaTypography.body.copyWith(color: AbbaColors.muted),
          ),
        ),
        const SizedBox(height: AbbaSpacing.sm),
        // Reveal message before cards appear
        if (_revealedCount == 0)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('📖', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: AbbaSpacing.lg),
                  Text(
                    widget.l10n.qtRevealMessage,
                    style: AbbaTypography.h2,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _hasPage2
                      ? PageView(
                          controller: _pageController,
                          onPageChanged: (page) {
                            setState(() => _currentPage = page);
                          },
                          children: [
                            _buildPage1(),
                            _buildPage2(),
                          ],
                        )
                      : _buildPage1(),
                ),
                // Page indicator + navigation hint
                if (_hasPage2 && _allRevealed) ...[
                  const SizedBox(height: AbbaSpacing.sm),
                  _buildPageIndicator(),
                  const SizedBox(height: AbbaSpacing.sm),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPage1() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.md),
      children: [
        for (int i = 0; i < _page1.length; i++)
          if (i < _revealedCount)
            SlideTransition(
              position: _slideAnimations[i],
              child: FadeTransition(
                opacity: _fadeAnimations[i],
                child: _QtCard(
                  passage: _page1[i],
                  locale: widget.locale,
                  l10n: widget.l10n,
                  isSelected: _selectedIndex == i,
                  isDimmed: _selectedIndex != null && _selectedIndex != i,
                  onTap: () => _selectCard(i),
                ),
              ),
            ),
        // Select prompt
        if (_allRevealed && _selectedIndex == null)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AbbaSpacing.lg,
              horizontal: AbbaSpacing.md,
            ),
            child: Text(
              widget.l10n.qtSelectPrompt,
              style: AbbaTypography.body.copyWith(
                color: AbbaColors.sage,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(height: AbbaSpacing.xl),
      ],
    );
  }

  Widget _buildPage2() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.md),
      children: [
        for (int i = 0; i < _page2.length; i++)
          _QtCard(
            passage: _page2[i],
            locale: widget.locale,
            l10n: widget.l10n,
            isSelected: _selectedIndex == (i + 5),
            isDimmed: _selectedIndex != null && _selectedIndex != (i + 5),
            onTap: () => _selectCard(i + 5),
          ),
        const SizedBox(height: AbbaSpacing.xl),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Page dots
        for (int i = 0; i < _pageCount; i++) ...[
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _currentPage == i ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _currentPage == i
                  ? AbbaColors.sage
                  : AbbaColors.muted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          if (i < _pageCount - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _QtCard extends StatelessWidget {
  final QTPassage passage;
  final String locale;
  final AppLocalizations l10n;
  final bool isSelected;
  final bool isDimmed;
  final VoidCallback onTap;

  const _QtCard({
    required this.passage,
    required this.locale,
    required this.l10n,
    required this.isSelected,
    required this.isDimmed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isDimmed ? 0.35 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(
          bottom: AbbaSpacing.md,
          left: isDimmed ? AbbaSpacing.md : 0,
          right: isDimmed ? AbbaSpacing.md : 0,
        ),
        child: Card(
          color: passage.color.withValues(alpha: isSelected ? 0.5 : 0.3),
          elevation: isSelected ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AbbaRadius.lg),
            side: isSelected
                ? const BorderSide(color: AbbaColors.sage, width: 2)
                : BorderSide.none,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(AbbaRadius.lg),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AbbaSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: icon + reference + completed check
                  Row(
                    children: [
                      Text(passage.icon, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: AbbaSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              passage.reference,
                              style: AbbaTypography.h2.copyWith(fontSize: 20),
                            ),
                            if (passage.topic.isNotEmpty)
                              Text(
                                passage.topic,
                                style: AbbaTypography.bodySmall.copyWith(
                                  color: AbbaColors.sage,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (passage.isCompleted)
                        Container(
                          padding: const EdgeInsets.all(AbbaSpacing.xs),
                          decoration: const BoxDecoration(
                            color: AbbaColors.sage,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 18,
                            color: AbbaColors.white,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AbbaSpacing.sm),
                  // Text preview or full
                  Text(
                    passage.text,
                    style: AbbaTypography.bodySmall,
                    maxLines: isSelected ? null : 2,
                    overflow: isSelected ? null : TextOverflow.ellipsis,
                  ),
                  // Meditate button (selected only)
                  if (isSelected) ...[
                    const SizedBox(height: AbbaSpacing.lg),
                    AbbaButton(
                      label: l10n.qtMeditateButton,
                      onPressed: () => _showRecording(context),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showRecording(BuildContext context) {
    qtLog.info('QT meditation started for ${passage.reference}');
    final container = ProviderScope.containerOf(context);
    container.read(currentPrayerModeProvider.notifier).state = 'qt';
    container.read(currentPassageRefProvider.notifier).state =
        passage.reference;
    container.read(currentPassageTextProvider.notifier).state =
        passage.text;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const RecordingOverlay(),
    );
  }
}
