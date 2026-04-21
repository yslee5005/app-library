import 'dart:async';

import 'package:app_lib_audio_recorder/audio_recorder.dart';
import 'package:app_lib_logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_button.dart';
import '../../../widgets/pro_modal.dart';
import '../../../widgets/prayer_heatmap.dart';

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
  Timer? _timer;
  final _textController = TextEditingController();
  late AnimationController _pulseController;
  String? _audioFilePath;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _textController.dispose();
    super.dispose();
  }

  // --- Prayer controls ---

  bool _isStarting = false;

  Future<void> _startPrayer() async {
    if (_isStarting) return;
    _isStarting = true;

    try {
      // Free user check
      final isPremium = ref.read(isPremiumProvider).value ?? false;
      final todayCount = ref.read(todayPrayerCountProvider);

      if (!isPremium && todayCount >= 1) {
        if (context.mounted) {
          final purchased = await showProPrompt(context);
          if (!purchased) return;
        }
      }

      ref.read(todayPrayerCountProvider.notifier).state = todayCount + 1;

      // Generate audio file path
      final dir = await getTemporaryDirectory();
      _audioFilePath =
          '${dir.path}/prayer_${DateTime.now().millisecondsSinceEpoch}.m4a';

      setState(() {
        _isPraying = true;
        _isPaused = false;
        _seconds = 0;
        _isTextMode = false;
      });
      ref.read(isRecordingProvider.notifier).state = true;

      _pulseController.repeat(reverse: true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!_isPaused && mounted) setState(() => _seconds++);
      });

      // Start audio recording
      final recorder = ref.read(audioRecorderServiceProvider);
      await recorder.startRecording(path: _audioFilePath!);

      prayerLog.info('Prayer recording started');
    } finally {
      _isStarting = false;
    }
  }

  void _togglePause() {
    final recorder = ref.read(audioRecorderServiceProvider);
    setState(() => _isPaused = !_isPaused);
    if (_isPaused) {
      _pulseController.stop();
      recorder.pauseRecording();
      prayerLog.info('Recording paused');
    } else {
      _pulseController.repeat(reverse: true);
      recorder.resumeRecording();
      prayerLog.info('Recording resumed');
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
                    backgroundColor: AbbaColors.sageDark,
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

    // Stop recording and get audio file path
    final recorder = ref.read(audioRecorderServiceProvider);
    final audioPath = await recorder.stopRecording();

    if (_isTextMode) {
      // Text mode: send transcript directly
      ref.read(currentTranscriptProvider.notifier).state =
          _textController.text;
      ref.read(currentAudioPathProvider.notifier).state = null;
    } else {
      // Voice mode: send audio file to Gemini
      ref.read(currentAudioPathProvider.notifier).state = audioPath;
      ref.read(currentTranscriptProvider.notifier).state = '';
    }
    ref.read(currentPrayerModeProvider.notifier).state = 'prayer';

    prayerLog.info(
      'Prayer finished, mode=${_isTextMode ? "text" : "voice"}, '
      'audioPath=$audioPath',
    );

    ref.read(isRecordingProvider.notifier).state = false;
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
                  // History button — tap to open my records
                  GestureDetector(
                    onTap: () => context.go('/home/my-records'),
                    child: Container(
                      padding: const EdgeInsets.all(AbbaSpacing.sm + 2),
                      decoration: BoxDecoration(
                        color: AbbaColors.sage.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AbbaRadius.xl),
                      ),
                      child: const Icon(
                        Icons.history,
                        size: 24,
                        color: AbbaColors.sage,
                      ),
                    ),
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
          if (!_isPraying) {
            setState(() => _selectedTab = index);
            final mode = index == 0 ? 'prayer' : 'qt';
            prayerLog.debug('Tab switched to $mode');
          }
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
        final circleSize = (h * 0.12).clamp(50.0, 90.0);
        final innerCircle = circleSize * 0.65;
        final emojiSize = circleSize * 0.3;
        final gap = (h * 0.015).clamp(4.0, 10.0);

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
                    child: Text('\u{1F64F}', style: TextStyle(fontSize: emojiSize)),
                  ),
                ),
              ),
            ),
            SizedBox(height: gap),
            // Streak status message
            _buildStreakStatus('prayer'),
            SizedBox(height: gap),
            // Prayer contribution heatmap
            _buildHeatmapCard('prayer'),
            SizedBox(height: gap),
            // Start button — "기도를 시작하세요"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.lg),
              child: AbbaButton(
                label: l10n.prayerStartPrompt,
                onPressed: _startPrayer,
                backgroundColor: AbbaColors.sageDark,
              ),
            ),
            const Spacer(flex: 1),
          ],
        );
      },
    );
  }

  Widget _buildStreakStatus(String mode) {
    final heatmapAsync = ref.watch(prayerHeatmapProvider(mode));
    final streakAsync = ref.watch(streakByModeProvider(mode));

    final streak = streakAsync.value?.current ?? 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 며칠째 안 했는지 계산 (heatmap 데이터에서)
    int daysSinceLastActivity = -1;
    final heatmapData = heatmapAsync.value;
    if (heatmapData != null) {
      for (int i = 0; i <= 84; i++) {
        final checkDate = today.subtract(Duration(days: i));
        final dateKey = DateTime(checkDate.year, checkDate.month, checkDate.day);
        if (heatmapData.containsKey(dateKey) && (heatmapData[dateKey]?.count ?? 0) > 0) {
          daysSinceLastActivity = i;
          break;
        }
      }
    }

    final isPrayer = mode == 'prayer';
    final activityName = isPrayer ? '기도' : 'QT';
    String emoji;
    String message;

    if (streak > 0 && daysSinceLastActivity <= 1) {
      emoji = '🔥';
      message = '$streak일째 연속 $activityName 중';
    } else if (daysSinceLastActivity == -1 || daysSinceLastActivity > 84) {
      emoji = '🌱';
      message = isPrayer ? '첫 기도를 시작해보세요' : '첫 QT를 시작해보세요';
    } else if (daysSinceLastActivity >= 2) {
      emoji = '😴';
      message = '$daysSinceLastActivity일째 $activityName을 쉬고 있어요';
    } else {
      emoji = isPrayer ? '🙏' : '📖';
      message = '오늘도 $activityName해보세요';
    }

    return Text(
      '$emoji $message',
      style: AbbaTypography.body.copyWith(
        color: AbbaColors.warmBrown,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildHeatmapCard(String mode) {
    final heatmapAsync = ref.watch(prayerHeatmapProvider(mode));
    final streakAsync = ref.watch(streakByModeProvider(mode));
    final streak = streakAsync.value?.current ?? 0;
    final isQtMode = mode == 'qt';
    final accentColor = isQtMode ? AbbaColors.softGold : AbbaColors.sage;

    return heatmapAsync.when(
      data: (data) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.lg),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AbbaSpacing.md,
              vertical: AbbaSpacing.md,
            ),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AbbaRadius.lg),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.12),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const labelWidth = 24.0;
                const spacing = 3.0;
                const weeks = 8;
                final availableWidth = constraints.maxWidth - labelWidth - AbbaSpacing.md * 2;
                final cols = weeks + 1;
                final cellSize = (availableWidth - (cols - 1) * spacing) / cols;

                return PrayerHeatmap(
                  data: data,
                  streakDays: streak,
                  weeks: weeks,
                  cellSize: cellSize.clamp(12.0, 30.0),
                  cellSpacing: spacing,
                  colorScheme: isQtMode
                      ? HeatmapColorScheme.gold
                      : HeatmapColorScheme.sage,
                );
              },
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  /// Build waveform widget — uses RecorderController if available, pulse fallback otherwise
  Widget _buildWaveformOrPulse() {
    final recorder = ref.read(audioRecorderServiceProvider);

    // Real recorder: show live waveform
    if (recorder is RealAudioRecorderService) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.xl),
        child: Column(
          children: [
            // Mic icon
            Icon(
              _isPaused ? Icons.pause_circle_outline : Icons.mic,
              size: 48,
              color: AbbaColors.sage,
            ),
            const SizedBox(height: AbbaSpacing.md),
            // Live waveform
            AudioWaveforms(
              size: const Size(double.infinity, 80),
              recorderController: recorder.controller,
              enableGesture: false,
              waveStyle: WaveStyle(
                waveColor: AbbaColors.sage,
                extendWaveform: true,
                showMiddleLine: false,
                spacing: 6.0,
                waveThickness: 3.0,
                showDurationLabel: false,
              ),
            ),
          ],
        ),
      );
    }

    // Mock: pulse animation fallback
    return AnimatedBuilder(
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
              onPressed: () async {
                final recorder = ref.read(audioRecorderServiceProvider);
                setState(() => _isTextMode = !_isTextMode);
                if (_isTextMode) {
                  await recorder.pauseRecording();
                  prayerLog.info('Switched to text mode');
                } else {
                  await recorder.resumeRecording();
                  prayerLog.info('Switched to voice mode');
                }
              },
              icon: Icon(
                _isTextMode ? Icons.mic : Icons.keyboard,
                size: 18,
                color: AbbaColors.sage,
              ),
              label: Text(
                _isTextMode ? l10n.switchToVoiceMode : l10n.switchToTextMode,
                style: AbbaTypography.caption.copyWith(color: AbbaColors.sage),
              ),
            ),
          ),
        ),
        const SizedBox(height: AbbaSpacing.md),
        // Waveform or text input
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
          _buildWaveformOrPulse(),
        const SizedBox(height: AbbaSpacing.md),
        // Timer
        Text(
          _formattedTime,
          style: AbbaTypography.hero.copyWith(fontSize: 36),
        ),
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
        final circleSize = (h * 0.12).clamp(50.0, 90.0);
        final innerCircle = circleSize * 0.65;
        final emojiSize = circleSize * 0.3;
        final gap = (h * 0.015).clamp(4.0, 10.0);

        return Column(
          children: [
            const Spacer(flex: 1),
            // Circle (gold accent)
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AbbaColors.softGold.withValues(alpha: 0.15),
              ),
              child: Center(
                child: Container(
                  width: innerCircle,
                  height: innerCircle,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AbbaColors.softGold,
                  ),
                  child: Center(
                    child: Text('\u{1F4D6}', style: TextStyle(fontSize: emojiSize)),
                  ),
                ),
              ),
            ),
            SizedBox(height: gap),
            // Streak status message (QT)
            _buildStreakStatus('qt'),
            SizedBox(height: gap),
            // QT contribution heatmap
            _buildHeatmapCard('qt'),
            SizedBox(height: gap),
            // Start button
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

