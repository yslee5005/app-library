import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/user_profile.dart';
import '../../../providers/providers.dart';
import '../../../services/error_logging_service.dart';
import '../../../services/stt_service.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_button.dart';
import '../../../widgets/premium_modal.dart';
import '../../../widgets/streak_garden.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0; // 0 = prayer, 1 = QT

  // Prayer state
  bool _isPraying = false;
  bool _isPaused = false;
  bool _isTextMode = false;
  int _seconds = 0;
  String _transcript = '';
  Timer? _timer;
  final _textController = TextEditingController();
  late AnimationController _pulseController;
  late SttService _sttService;
  bool _sttInitialized = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _sttService = ref.read(sttServiceProvider);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _textController.dispose();
    if (_sttInitialized) _sttService.stopListening();
    super.dispose();
  }

  // --- Prayer controls ---

  Future<void> _startPrayer() async {
    // Free user check
    final profile = ref.read(userProfileProvider).valueOrNull;
    final isFree = profile?.subscription == SubscriptionStatus.free;
    final todayCount = ref.read(todayPrayerCountProvider);

    if (isFree && todayCount >= 1) {
      if (context.mounted) {
        final purchased = await showPremiumModal(context);
        if (!purchased) return;
      }
    }

    ref.read(todayPrayerCountProvider.notifier).state = todayCount + 1;

    setState(() {
      _isPraying = true;
      _isPaused = false;
      _seconds = 0;
      _transcript = '';
      _isTextMode = false;
    });

    _pulseController.repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPaused && mounted) setState(() => _seconds++);
    });

    ErrorLoggingService.addBreadcrumb('Prayer started', category: 'prayer');
    _startStt();
  }

  void _startStt() {
    final locale = ref.read(localeProvider);
    _sttService.initialize().then((_) {
      _sttInitialized = true;
      final sttLocale = switch (locale) {
        'ko' => 'ko_KR',
        'ja' => 'ja_JP',
        'es' => 'es_ES',
        'zh' => 'zh_CN',
        _ => 'en_US',
      };
      _sttService.setLocale(sttLocale);
      _sttService.startListening(
        onResult: (text, isFinal) {
          if (mounted) setState(() => _transcript = text);
        },
        onError: (_) {
          if (mounted) setState(() => _isTextMode = true);
        },
      );
    });
  }

  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
    if (_isPaused) {
      _pulseController.stop();
      _sttService.stopListening();
    } else {
      _pulseController.repeat(reverse: true);
      _startStt();
    }
  }

  Future<void> _finishPrayer() async {
    final l10n = AppLocalizations.of(context)!;

    // 기도 완료 확인 다이얼로그 (실수 방지)
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AbbaRadius.lg),
        ),
        title: Text(
          '🙏 ${l10n.finishPrayer}',
          style: AbbaTypography.h2,
          textAlign: TextAlign.center,
        ),
        content: Text(
          l10n.finishPrayerConfirm,
          style: AbbaTypography.body,
          textAlign: TextAlign.center,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AbbaSpacing.lg, 0, AbbaSpacing.lg, AbbaSpacing.lg,
        ),
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: abbaButtonHeight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AbbaColors.sage,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AbbaRadius.md),
                    ),
                  ),
                  child: Text(
                    l10n.finishPrayer,
                    style: AbbaTypography.body.copyWith(color: AbbaColors.white),
                  ),
                ),
              ),
              const SizedBox(height: AbbaSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: abbaButtonHeight,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AbbaColors.sage),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AbbaRadius.md),
                    ),
                  ),
                  child: Text(
                    l10n.recordingResume,
                    style: AbbaTypography.body.copyWith(color: AbbaColors.sage),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    _timer?.cancel();
    _pulseController.stop();
    _sttService.stopListening();

    final transcript = _isTextMode ? _textController.text : _transcript;
    ref.read(currentTranscriptProvider.notifier).state = transcript;
    ref.read(currentPrayerModeProvider.notifier).state = 'prayer';

    ErrorLoggingService.addBreadcrumb('Prayer finished', category: 'prayer');

    setState(() => _isPraying = false);
    if (mounted) context.go('/home/ai-loading');
  }

  // --- Build ---

  String get _formattedTime {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP: Tab bar + Streak (single row, no scrolling) ---
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AbbaSpacing.md, AbbaSpacing.sm, AbbaSpacing.md, 0,
              ),
              child: Row(
                children: [
                  // Tab bar (takes available space)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AbbaColors.warmBrown.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(AbbaRadius.xl),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        children: [
                          _buildTab(0, '🎙️ ${l10n.prayButton}'),
                          _buildTab(1, '📖 ${l10n.qtButton}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AbbaSpacing.sm),
                  // Streak badge (compact)
                  profileAsync.when(
                    data: (profile) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AbbaSpacing.sm + 2,
                        vertical: AbbaSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AbbaColors.sage.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AbbaRadius.xl),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            streakGardenIcon(profile.currentStreak),
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${profile.currentStreak}',
                            style: AbbaTypography.body.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AbbaColors.sage,
                            ),
                          ),
                        ],
                      ),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (e, s) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AbbaSpacing.sm),

            // --- CONTENT ---
            Expanded(
              child: _selectedTab == 0
                  ? _buildPrayerTab(l10n)
                  : _buildQtTab(l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final selected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!_isPraying) setState(() => _selectedTab = index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AbbaSpacing.sm + 2),
          decoration: BoxDecoration(
            color: selected ? AbbaColors.sage : Colors.transparent,
            borderRadius: BorderRadius.circular(AbbaRadius.xl - 2),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.xs),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: AbbaTypography.body.copyWith(
                  color: selected ? AbbaColors.white : AbbaColors.warmBrown,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Prayer Tab ---

  Widget _buildPrayerTab(AppLocalizations l10n) {
    if (_isPraying) return _buildActivePrayer(l10n);
    return _buildPrayerIdle(l10n);
  }

  Widget _buildPrayerIdle(AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final circleSize = (h * 0.15).clamp(60.0, 110.0);
        final innerCircle = circleSize * 0.65;
        final emojiSize = circleSize * 0.3;
        final gap = (h * 0.02).clamp(4.0, 12.0);

        return Column(
          children: [
            const Spacer(flex: 1),
            // Circle
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AbbaColors.sage.withValues(alpha: 0.15),
              ),
              child: Center(
                child: Container(
                  width: innerCircle,
                  height: innerCircle,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AbbaColors.sage,
                  ),
                  child: Center(
                    child: Text('🙏', style: TextStyle(fontSize: emojiSize)),
                  ),
                ),
              ),
            ),
            SizedBox(height: gap),
            Text(
              l10n.prayerStartPrompt,
              style: AbbaTypography.h2.copyWith(color: AbbaColors.warmBrown),
            ),
            SizedBox(height: gap),
            // Guide tips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.lg),
              child: Container(
                padding: const EdgeInsets.all(AbbaSpacing.sm),
                decoration: BoxDecoration(
                  color: AbbaColors.sage.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AbbaRadius.lg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.prayerGuideTitle,
                      style: AbbaTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AbbaColors.sage,
                      ),
                    ),
                    const SizedBox(height: AbbaSpacing.xs),
                    _GuideRow(icon: '🎙️', text: l10n.prayerGuide1),
                    const SizedBox(height: 2),
                    _GuideRow(icon: '✝️', text: l10n.prayerGuide2),
                    const SizedBox(height: 2),
                    _GuideRow(icon: '⌨️', text: l10n.prayerGuide3),
                  ],
                ),
              ),
            ),
            SizedBox(height: gap),
            // Start button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.lg),
              child: AbbaButton(
                label: l10n.startPrayerButton,
                onPressed: _startPrayer,
                backgroundColor: AbbaColors.sage,
              ),
            ),
            const Spacer(flex: 1),
          ],
        );
      },
    );
  }

  Widget _buildActivePrayer(AppLocalizations l10n) {
    return Column(
      children: [
        // Text mode toggle (top right)
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: AbbaSpacing.lg),
            child: TextButton.icon(
              onPressed: () {
                setState(() => _isTextMode = !_isTextMode);
                if (_isTextMode) {
                  _sttService.stopListening();
                  _textController.text = _transcript;
                } else {
                  _startStt();
                }
              },
              icon: Icon(
                _isTextMode ? Icons.mic : Icons.keyboard,
                size: 18,
                color: AbbaColors.sage,
              ),
              label: Text(
                l10n.switchToTextMode,
                style: AbbaTypography.caption.copyWith(color: AbbaColors.sage),
              ),
            ),
          ),
        ),
        const SizedBox(height: AbbaSpacing.md),
        // Pulse circle or text input
        if (_isTextMode)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.xl),
            child: TextField(
              controller: _textController,
              maxLines: 6,
              style: AbbaTypography.body,
              decoration: InputDecoration(
                hintText: l10n.textInputHint,
                hintStyle: AbbaTypography.body.copyWith(color: AbbaColors.muted),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AbbaRadius.lg),
                  borderSide: const BorderSide(color: AbbaColors.sage),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AbbaRadius.lg),
                  borderSide: const BorderSide(color: AbbaColors.sage, width: 2),
                ),
                filled: true,
                fillColor: AbbaColors.white,
                contentPadding: const EdgeInsets.all(AbbaSpacing.md),
              ),
            ),
          )
        else
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final scale = 1.0 + (_pulseController.value * 0.12);
              return Transform.scale(
                scale: _isPaused ? 1.0 : scale,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AbbaColors.sage.withValues(
                      alpha: 0.15 + (_pulseController.value * 0.1),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AbbaColors.sage,
                      ),
                      child: Icon(
                        _isPaused ? Icons.pause : Icons.mic,
                        size: 48,
                        color: AbbaColors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: AbbaSpacing.md),
        // Timer
        Text(
          _formattedTime,
          style: AbbaTypography.hero.copyWith(fontSize: 36),
        ),
        const SizedBox(height: AbbaSpacing.md),
        // Transcript accumulation area
        if (!_isTextMode)
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: AbbaSpacing.xl),
              child: Text(
                _transcript,
                style: AbbaTypography.body.copyWith(
                  color: AbbaColors.warmBrown,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          const Spacer(),
        // Controls
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.xl),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: abbaButtonHeight,
                  child: OutlinedButton(
                    onPressed: _togglePause,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AbbaColors.sage),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AbbaRadius.lg),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isPaused ? Icons.play_arrow : Icons.pause,
                            color: AbbaColors.sage,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isPaused ? l10n.recordingResume : l10n.recordingPause,
                            style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.sage),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AbbaSpacing.md),
              Expanded(
                child: AbbaButton(
                  label: l10n.finishPrayer,
                  onPressed: _finishPrayer,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AbbaSpacing.xxl),
      ],
    );
  }

  // --- QT Tab ---

  Widget _buildQtTab(AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final emojiSize = (h * 0.08).clamp(32.0, 48.0);
        final gap = (h * 0.02).clamp(4.0, 12.0);

        return Column(
          children: [
            const Spacer(flex: 1),
            Text('📖', style: TextStyle(fontSize: emojiSize)),
            SizedBox(height: gap),
            Text(
              l10n.qtRevealMessage,
              style: AbbaTypography.h2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: gap),
            // Guide tips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.lg),
              child: Container(
                padding: const EdgeInsets.all(AbbaSpacing.sm),
                decoration: BoxDecoration(
                  color: AbbaColors.softGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AbbaRadius.lg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.qtGuideTitle,
                      style: AbbaTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AbbaColors.softGold,
                      ),
                    ),
                    const SizedBox(height: AbbaSpacing.xs),
                    _GuideRow(icon: '📖', text: l10n.qtGuide1),
                    const SizedBox(height: 2),
                    _GuideRow(icon: '💬', text: l10n.qtGuide2),
                    const SizedBox(height: 2),
                    _GuideRow(icon: '✏️', text: l10n.qtGuide3),
                  ],
                ),
              ),
            ),
            SizedBox(height: gap),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.lg),
              child: AbbaButton(
                label: l10n.qtButton,
                onPressed: () => context.go('/home/qt'),
                backgroundColor: AbbaColors.softGold,
              ),
            ),
            const Spacer(flex: 1),
          ],
        );
      },
    );
  }
}

class _GuideRow extends StatelessWidget {
  final String icon;
  final String text;

  const _GuideRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AbbaSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: AbbaSpacing.md),
          Expanded(
            child: Text(
              text,
              style: AbbaTypography.bodySmall.copyWith(
                color: AbbaColors.warmBrown,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
