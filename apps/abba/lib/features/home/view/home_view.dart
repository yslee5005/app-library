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
import '../../../widgets/abba_card.dart';
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

  void _finishPrayer() {
    _timer?.cancel();
    _pulseController.stop();
    _sttService.stopListening();

    final transcript = _isTextMode ? _textController.text : _transcript;
    ref.read(currentTranscriptProvider.notifier).state = transcript;
    ref.read(currentPrayerModeProvider.notifier).state = 'prayer';

    ErrorLoggingService.addBreadcrumb('Prayer finished', category: 'prayer');

    setState(() => _isPraying = false);
    context.go('/home/ai-loading');
  }

  // --- Build ---

  String _getGreeting(AppLocalizations l10n, String name) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.greetingMorning(name);
    if (hour < 18) return l10n.greetingAfternoon(name);
    return l10n.greetingEvening(name);
  }

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
            // --- TOP: Greeting + Streak ---
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AbbaSpacing.lg, AbbaSpacing.md, AbbaSpacing.lg, 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  profileAsync.when(
                    data: (p) => Text(
                      _getGreeting(l10n, p.name),
                      style: AbbaTypography.h1,
                    ),
                    loading: () => Text(
                      _getGreeting(l10n, ''),
                      style: AbbaTypography.h1,
                    ),
                    error: (e, s) => Text(
                      _getGreeting(l10n, ''),
                      style: AbbaTypography.h1,
                    ),
                  ),
                  const SizedBox(height: AbbaSpacing.md),
                  // Streak card
                  profileAsync.when(
                    data: (profile) => AbbaCard(
                      margin: EdgeInsets.zero,
                      child: Row(
                        children: [
                          Text(
                            streakGardenIcon(profile.currentStreak),
                            style: const TextStyle(fontSize: 36),
                          ),
                          const SizedBox(width: AbbaSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.streakDays(profile.currentStreak),
                                  style: AbbaTypography.h2,
                                ),
                                Text(
                                  streakGardenLabel(
                                    profile.currentStreak,
                                    l10n,
                                  ),
                                  style: AbbaTypography.caption.copyWith(
                                    color: AbbaColors.muted,
                                  ),
                                ),
                              ],
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

            const SizedBox(height: AbbaSpacing.md),

            // --- TAB BAR ---
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AbbaSpacing.lg),
              child: Container(
                decoration: BoxDecoration(
                  color: AbbaColors.warmBrown.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AbbaRadius.xl),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _buildTab(0, '🎙️ ${l10n.prayButton}'),
                    _buildTab(1, '📖 ${l10n.qtButton}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AbbaSpacing.md),

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
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AbbaTypography.body.copyWith(
              color: selected ? AbbaColors.white : AbbaColors.warmBrown,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AbbaSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        // Static circle
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AbbaColors.sage.withValues(alpha: 0.15),
          ),
          child: Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AbbaColors.sage,
              ),
              child: const Center(
                child: Text('🙏', style: TextStyle(fontSize: 48)),
              ),
            ),
          ),
        ),
        const SizedBox(height: AbbaSpacing.lg),
        Text(
          l10n.prayerStartPrompt,
          style: AbbaTypography.h2.copyWith(color: AbbaColors.warmBrown),
        ),
        const SizedBox(height: AbbaSpacing.lg),
        // Guide tips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.xl),
          child: Container(
            padding: const EdgeInsets.all(AbbaSpacing.md),
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
                const SizedBox(height: AbbaSpacing.sm),
                _GuideRow(icon: '🎙️', text: l10n.prayerGuide1),
                const SizedBox(height: AbbaSpacing.xs),
                _GuideRow(icon: '✝️', text: l10n.prayerGuide2),
                const SizedBox(height: AbbaSpacing.xs),
                _GuideRow(icon: '⌨️', text: l10n.prayerGuide3),
              ],
            ),
          ),
        ),
        const SizedBox(height: AbbaSpacing.xl),
        // Start button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.xl),
          child: AbbaButton(
            label: l10n.startPrayerButton,
            onPressed: _startPrayer,
            isHero: true,
            backgroundColor: AbbaColors.sage,
          ),
        ),
        const SizedBox(height: AbbaSpacing.lg),
          ],
        ),
      ),
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
                  child: OutlinedButton.icon(
                    onPressed: _togglePause,
                    icon: Icon(
                      _isPaused ? Icons.play_arrow : Icons.pause,
                      color: AbbaColors.sage,
                    ),
                    label: Text(
                      _isPaused ? l10n.recordingResume : l10n.recordingPause,
                      style:
                          AbbaTypography.body.copyWith(color: AbbaColors.sage),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AbbaColors.sage),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AbbaRadius.lg),
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AbbaSpacing.md,
          vertical: AbbaSpacing.xl,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: AbbaSpacing.xxl),
            const Text('📖', style: TextStyle(fontSize: 64)),
            const SizedBox(height: AbbaSpacing.lg),
            Text(
              l10n.qtRevealMessage,
              style: AbbaTypography.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AbbaSpacing.xl),
            // Guide tips
            Container(
              padding: const EdgeInsets.all(AbbaSpacing.md),
              margin: const EdgeInsets.symmetric(horizontal: AbbaSpacing.md),
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
                  const SizedBox(height: AbbaSpacing.sm),
                  _GuideRow(icon: '📖', text: l10n.qtGuide1),
                  const SizedBox(height: AbbaSpacing.xs),
                  _GuideRow(icon: '💬', text: l10n.qtGuide2),
                  const SizedBox(height: AbbaSpacing.xs),
                  _GuideRow(icon: '✏️', text: l10n.qtGuide3),
                ],
              ),
            ),
            const SizedBox(height: AbbaSpacing.xl),
            AbbaButton(
              label: l10n.qtButton,
              onPressed: () => context.go('/home/qt'),
              isHero: true,
              backgroundColor: AbbaColors.softGold,
            ),
            const SizedBox(height: AbbaSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _GuideRow extends StatelessWidget {
  final String icon;
  final String text;

  const _GuideRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: AbbaSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AbbaTypography.bodySmall.copyWith(
              color: AbbaColors.warmBrown,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
