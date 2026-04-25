import 'dart:async';
import 'dart:io';

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
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int _selectedTab = 0; // 0 = prayer, 1 = QT

  // Prayer state
  bool _isPraying = false;
  bool _isPaused = false;
  bool _isTextMode = false;
  // Locks the active session to text-only after the user destructively
  // switches from voice → text via the toggle (Wave A fix #2). Reset on
  // session start.
  bool _textOnlyLocked = false;
  // Set when the OS pauses the app while we're in voice mode mid-session
  // (Wave A fix #3). When the user resumes we show a recovery dialog.
  bool _interruptedDuringPause = false;
  int _seconds = 0;
  Timer? _timer;
  final _textController = TextEditingController();
  late AnimationController _pulseController;
  String? _audioFilePath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    // Rebuild the "기도 마침" button when the user types so the disabled
    // gate on too-short text mode input flips live.
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _pulseController.dispose();
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  /// Minimum trimmed text length required to send a text-mode prayer to
  /// Gemini. Wave A fix #1 — empty/short text must not consume quota or
  /// hit the AI gateway.
  static const int _minTextLength = 5;

  /// True when we should accept the current "기도 마침" tap. Voice mode
  /// always passes (Gemini transcribes). Text mode requires ≥5 trimmed
  /// chars.
  bool get _canFinishPrayer {
    if (!_isTextMode) return true;
    return _textController.text.trim().length >= _minTextLength;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Wave A fix #3 — App lifecycle background guard.
    // When the OS suspends the app mid voice-recording, immediately stop
    // the recorder so we don't burn battery / mic in the background and
    // so the audio file is finalized before iOS may revoke our mic
    // session. We DON'T discard the file here; on resume we ask the
    // user what to do.
    if (!_isPraying || _isTextMode) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      if (!_interruptedDuringPause) {
        _interruptedDuringPause = true;
        _timer?.cancel();
        _pulseController.stop();
        final recorder = ref.read(audioRecorderServiceProvider);
        // Fire-and-forget: stopRecording is async but the framework
        // doesn't await us in didChangeAppLifecycleState.
        recorder.stopRecording().catchError((Object e, StackTrace st) {
          prayerLog.warning('stopRecording on pause failed: $e');
          return null;
        });
        prayerLog.info(
          'Recording auto-stopped due to app lifecycle pause',
        );
      }
    } else if (state == AppLifecycleState.resumed &&
        _interruptedDuringPause &&
        mounted) {
      // Trigger the recovery dialog on the next frame so the build
      // tree is fully attached before showDialog.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showRecordingInterruptedDialog();
      });
    }
  }

  // --- Prayer controls ---

  bool _isStarting = false;

  Future<void> _startPrayer() async {
    if (_isStarting) return;
    _isStarting = true;

    try {
      // Resolve tier + limit. Errors default to the strictest path
      // (free = 1/day) — fail closed so we never accidentally grant
      // unlimited access to a free user.
      final tier = await ref
          .read(effectiveTierProvider.future)
          .catchError((_) => EffectiveTier.free);
      final limit = await ref
          .read(dailyPrayerLimitProvider.future)
          .catchError((_) => 1);

      final quota = ref.read(prayerQuotaServiceProvider);
      final canStart = await quota.canStart(limit: limit);

      if (!canStart) {
        if (!mounted) return;
        // ignore: use_build_context_synchronously
        await (tier == EffectiveTier.trial
            ? showTrialLimitPrompt(context)
            : showProPrompt(context));
        // Do NOT start recording, do NOT increment.
        return;
      }

      // Generate audio file path
      final dir = await getTemporaryDirectory();
      _audioFilePath =
          '${dir.path}/prayer_${DateTime.now().millisecondsSinceEpoch}.m4a';

      setState(() {
        _isPraying = true;
        _isPaused = false;
        _seconds = 0;
        _isTextMode = false;
        _textOnlyLocked = false;
        _interruptedDuringPause = false;
        _textController.clear();
      });
      ref.read(isRecordingProvider.notifier).state = true;

      _pulseController.repeat(reverse: true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!_isPaused && mounted) setState(() => _seconds++);
      });

      // Start audio recording — increment quota only after the recorder
      // actually starts. If startRecording throws we bail without
      // consuming the user's daily slot.
      final recorder = ref.read(audioRecorderServiceProvider);
      try {
        await recorder.startRecording(path: _audioFilePath!);
      } catch (e) {
        _timer?.cancel();
        _pulseController.stop();
        if (mounted) {
          setState(() => _isPraying = false);
        }
        ref.read(isRecordingProvider.notifier).state = false;
        rethrow;
      }
      await quota.increment();

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

    // Wave A fix #1 — guard text-mode finish against empty / too-short
    // input. The button is also visually disabled by `_canFinishPrayer`,
    // but this is the authoritative check (covers programmatic taps).
    // No Gemini call, no quota debit, no DB row.
    if (_isTextMode &&
        _textController.text.trim().length < _minTextLength) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.prayerTooShort)),
      );
      return;
    }

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
          AbbaSpacing.lg,
          0,
          AbbaSpacing.lg,
          AbbaSpacing.lg,
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
                    style: AbbaTypography.body.copyWith(
                      color: AbbaColors.white,
                    ),
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
      ref.read(currentTranscriptProvider.notifier).state = _textController.text;
      ref.read(currentAudioPathProvider.notifier).state = null;
    } else {
      // Voice mode: send audio file to Gemini
      ref.read(currentAudioPathProvider.notifier).state = audioPath;
      ref.read(currentTranscriptProvider.notifier).state = '';
    }
    ref.read(currentPrayerModeProvider.notifier).state = 'prayer';

    prayerLog.info(
      'Prayer finished, mode=${_isTextMode ? "text" : "voice"}, '
      'audioPath=${_isTextMode ? "(text mode, no audio)" : audioPath}',
    );

    ref.read(isRecordingProvider.notifier).state = false;
    setState(() => _isPraying = false);
    if (mounted) context.go('/home/ai-loading');
  }

  /// Wave A fix #2 — Destructive switch from voice → text.
  ///
  /// While a voice session is active, tapping the toggle:
  ///   1. Shows a confirm dialog (cancel = no-op).
  ///   2. On confirm: stops the recorder, deletes the in-progress
  ///      audio file, clears `currentAudioPathProvider`, resets the
  ///      visible timer, locks the session text-only.
  ///
  /// Going back from text → voice is forbidden once locked because the
  /// audio context has been destroyed.
  Future<void> _onToggleTextMode() async {
    final l10n = AppLocalizations.of(context)!;

    // No active voice recording (e.g. switching from text → voice
    // before any voice was captured) — but in our flow voice is the
    // default starting mode, so this branch only fires on a hypothetical
    // "voice toggle while in text mode but not locked" path. Today
    // _textOnlyLocked guards that. Safe early return.
    if (_isTextMode) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AbbaRadius.lg),
        ),
        title: Text(
          l10n.switchToTextModeTitle,
          style: AbbaTypography.h2,
          textAlign: TextAlign.center,
        ),
        content: Text(
          l10n.switchToTextModeBody,
          style: AbbaTypography.body,
          textAlign: TextAlign.center,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AbbaSpacing.lg,
          0,
          AbbaSpacing.lg,
          AbbaSpacing.lg,
        ),
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: abbaButtonHeight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AbbaColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AbbaRadius.md),
                    ),
                  ),
                  child: Text(
                    l10n.switchToTextModeConfirm,
                    style: AbbaTypography.body.copyWith(
                      color: AbbaColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AbbaSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: abbaButtonHeight,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AbbaColors.sage),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AbbaRadius.md),
                    ),
                  ),
                  child: Text(
                    l10n.switchToTextModeCancel,
                    style: AbbaTypography.body.copyWith(
                      color: AbbaColors.sage,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    // Stop + discard.
    final recorder = ref.read(audioRecorderServiceProvider);
    try {
      await recorder.stopRecording();
    } catch (e) {
      prayerLog.warning('stopRecording during destructive switch failed: $e');
    }

    // Best-effort delete of the in-progress audio file.
    final path = _audioFilePath;
    if (path != null) {
      try {
        final f = File(path);
        if (await f.exists()) await f.delete();
      } catch (e) {
        prayerLog.warning('Failed to delete recording file $path: $e');
      }
    }

    // Reset state — timer to zero, audio path cleared, lock to text.
    _timer?.cancel();
    _pulseController.stop();
    ref.read(currentAudioPathProvider.notifier).state = null;

    if (!mounted) return;
    setState(() {
      _isTextMode = true;
      _textOnlyLocked = true;
      _isPaused = false;
      _seconds = 0;
      _audioFilePath = null;
    });

    // Restart timer so the user still sees session duration after switch.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPaused && mounted) setState(() => _seconds++);
    });

    prayerLog.info('Destructively switched to text-only mode');
  }

  /// Wave A fix #3 — Recording interrupted recovery dialog.
  ///
  /// Shown after [didChangeAppLifecycleState] auto-stopped the recorder
  /// because the app was suspended mid voice-recording. Three options:
  ///   - 다시 시작 (restart): start a new voice session (fresh file)
  ///   - 텍스트로 작성 (switch to text): lock session text-only
  ///   - 폐기 (discard): exit the prayer session entirely
  Future<void> _showRecordingInterruptedDialog() async {
    if (!mounted || !_isPraying) return;
    // Reset the flag now so re-entering paused→resumed cycle doesn't
    // re-fire the dialog while it's already up.
    _interruptedDuringPause = false;

    final l10n = AppLocalizations.of(context)!;
    final choice = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AbbaRadius.lg),
        ),
        title: Text(
          l10n.recordingInterruptedTitle,
          style: AbbaTypography.h2,
          textAlign: TextAlign.center,
        ),
        content: Text(
          l10n.recordingInterruptedBody,
          style: AbbaTypography.body,
          textAlign: TextAlign.center,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AbbaSpacing.lg,
          0,
          AbbaSpacing.lg,
          AbbaSpacing.lg,
        ),
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: abbaButtonHeight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, 'restart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AbbaColors.sageDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AbbaRadius.md),
                    ),
                  ),
                  child: Text(
                    l10n.recordingInterruptedRestart,
                    style: AbbaTypography.body.copyWith(
                      color: AbbaColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AbbaSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: abbaButtonHeight,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx, 'text'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AbbaColors.sage),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AbbaRadius.md),
                    ),
                  ),
                  child: Text(
                    l10n.recordingInterruptedSwitchToText,
                    style: AbbaTypography.body.copyWith(
                      color: AbbaColors.sage,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AbbaSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: abbaButtonHeight,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx, 'discard'),
                  child: Text(
                    l10n.leaveButton,
                    style: AbbaTypography.body.copyWith(
                      color: AbbaColors.error,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (!mounted) return;

    switch (choice) {
      case 'restart':
        // Discard the half-baked audio file then start fresh.
        final old = _audioFilePath;
        if (old != null) {
          try {
            final f = File(old);
            if (await f.exists()) await f.delete();
          } catch (e) {
            prayerLog.warning('Failed to delete old recording $old: $e');
          }
        }
        if (!mounted) return;
        try {
          final dir = await getTemporaryDirectory();
          _audioFilePath =
              '${dir.path}/prayer_${DateTime.now().millisecondsSinceEpoch}.m4a';
          final recorder = ref.read(audioRecorderServiceProvider);
          await recorder.startRecording(path: _audioFilePath!);
          if (!mounted) return;
          setState(() {
            _isPaused = false;
            _seconds = 0;
            _isTextMode = false;
            _textOnlyLocked = false;
          });
          _pulseController.repeat(reverse: true);
          _timer = Timer.periodic(const Duration(seconds: 1), (_) {
            if (!_isPaused && mounted) setState(() => _seconds++);
          });
          prayerLog.info('Recording restarted after lifecycle interrupt');
        } catch (e) {
          prayerLog.warning('Failed to restart recording: $e');
          if (!mounted) return;
          // Fall back to ending the session — recovery is best-effort.
          _resetPrayerSession();
        }
        break;
      case 'text':
        // Switch to text-only — discard any partial audio.
        final path = _audioFilePath;
        if (path != null) {
          try {
            final f = File(path);
            if (await f.exists()) await f.delete();
          } catch (e) {
            prayerLog.warning('Failed to delete recording $path: $e');
          }
        }
        if (!mounted) return;
        ref.read(currentAudioPathProvider.notifier).state = null;
        setState(() {
          _isTextMode = true;
          _textOnlyLocked = true;
          _isPaused = false;
          _audioFilePath = null;
        });
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (!_isPaused && mounted) setState(() => _seconds++);
        });
        prayerLog.info('Switched to text-only after lifecycle interrupt');
        break;
      case 'discard':
      default:
        final path = _audioFilePath;
        if (path != null) {
          try {
            final f = File(path);
            if (await f.exists()) await f.delete();
          } catch (e) {
            prayerLog.warning('Failed to delete recording $path: $e');
          }
        }
        _resetPrayerSession();
        prayerLog.info('Prayer session discarded after lifecycle interrupt');
        break;
    }
  }

  /// Tear down active prayer state cleanly. Does not stop the recorder
  /// (caller is expected to have already done so).
  void _resetPrayerSession() {
    _timer?.cancel();
    _pulseController.stop();
    ref.read(isRecordingProvider.notifier).state = false;
    ref.read(currentAudioPathProvider.notifier).state = null;
    if (!mounted) return;
    setState(() {
      _isPraying = false;
      _isPaused = false;
      _isTextMode = false;
      _textOnlyLocked = false;
      _seconds = 0;
      _audioFilePath = null;
    });
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
                AbbaSpacing.md,
                AbbaSpacing.sm,
                AbbaSpacing.md,
                0,
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
                    child: Text(
                      '\u{1F64F}',
                      style: TextStyle(fontSize: emojiSize),
                    ),
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
    final l10n = AppLocalizations.of(context)!;
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
        final dateKey = DateTime(
          checkDate.year,
          checkDate.month,
          checkDate.day,
        );
        if (heatmapData.containsKey(dateKey) &&
            (heatmapData[dateKey]?.count ?? 0) > 0) {
          daysSinceLastActivity = i;
          break;
        }
      }
    }

    final isPrayer = mode == 'prayer';
    final activityName = isPrayer
        ? l10n.homeActivityPrayer
        : l10n.homeActivityQt;
    String emoji;
    String message;

    if (streak > 0 && daysSinceLastActivity <= 1) {
      emoji = '🔥';
      message = l10n.homeStreakInProgress(streak, activityName);
    } else if (daysSinceLastActivity == -1 || daysSinceLastActivity > 84) {
      emoji = '🌱';
      message = isPrayer ? l10n.homeFirstPrayerPrompt : l10n.homeFirstQtPrompt;
    } else if (daysSinceLastActivity >= 2) {
      emoji = '😴';
      message = l10n.homeDaysSinceLastActivity(
        daysSinceLastActivity,
        activityName,
      );
    } else {
      emoji = isPrayer ? '🙏' : '📖';
      message = l10n.homeActivityPrompt(activityName);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.md),
      child: Text(
        '$emoji $message',
        style: AbbaTypography.body.copyWith(
          color: AbbaColors.warmBrown,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
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
              border: Border.all(color: accentColor.withValues(alpha: 0.12)),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const labelWidth = 24.0;
                const spacing = 3.0;
                const weeks = 8;
                final availableWidth =
                    constraints.maxWidth - labelWidth - AbbaSpacing.md * 2;
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 520;
        final gap = compact ? AbbaSpacing.sm : AbbaSpacing.md;
        final horizontalPadding = compact ? AbbaSpacing.lg : AbbaSpacing.xl;
        final timerSize = compact ? 32.0 : 36.0;
        final bottomGap = compact ? AbbaSpacing.sm : AbbaSpacing.lg;

        return Column(
          children: [
            // Text mode toggle (top right)
            // Wave A fix #2 — switching from voice → text is destructive
            // (audio file is deleted, session locked text-only). Switch
            // shows a confirm dialog. Already-text-mode locked sessions
            // disable the toggle entirely.
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: horizontalPadding),
                child: TextButton.icon(
                  onPressed: _textOnlyLocked
                      ? null
                      : () => _onToggleTextMode(),
                  icon: Icon(
                    _isTextMode ? Icons.mic : Icons.keyboard,
                    size: 18,
                    color: _textOnlyLocked
                        ? AbbaColors.muted
                        : AbbaColors.sage,
                  ),
                  label: Text(
                    _isTextMode
                        ? l10n.switchToVoiceMode
                        : l10n.switchToTextMode,
                    style: AbbaTypography.caption.copyWith(
                      color: _textOnlyLocked
                          ? AbbaColors.muted
                          : AbbaColors.sage,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: gap),
            // Waveform or text input. This flexes so text mode cannot push the
            // timer/buttons off-screen on shorter devices.
            Expanded(
              child: _isTextMode
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: TextField(
                        controller: _textController,
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        style: AbbaTypography.body,
                        decoration: InputDecoration(
                          hintText: l10n.textInputHint,
                          hintStyle: AbbaTypography.body.copyWith(
                            color: AbbaColors.muted,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AbbaRadius.lg),
                            borderSide: const BorderSide(
                              color: AbbaColors.sage,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AbbaRadius.lg),
                            borderSide: const BorderSide(
                              color: AbbaColors.sage,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: AbbaColors.white,
                          contentPadding: const EdgeInsets.all(AbbaSpacing.md),
                        ),
                      ),
                    )
                  : Center(child: _buildWaveformOrPulse()),
            ),
            SizedBox(height: gap),
            // Timer
            Text(
              _formattedTime,
              style: AbbaTypography.hero.copyWith(fontSize: timerSize),
            ),
            SizedBox(height: gap),
            // Controls
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                                _isPaused
                                    ? l10n.recordingResume
                                    : l10n.recordingPause,
                                style: AbbaTypography.bodySmall.copyWith(
                                  color: AbbaColors.sage,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AbbaSpacing.md),
                  Expanded(
                    // Wave A fix #1 — disable finish when text-mode
                    // input is empty / under the minimum length. A real
                    // tap is also guarded inside `_finishPrayer` so a
                    // programmatic / a11y route can't bypass.
                    child: Opacity(
                      opacity: _canFinishPrayer ? 1.0 : 0.4,
                      child: AbsorbPointer(
                        absorbing: !_canFinishPrayer,
                        child: AbbaButton(
                          label: l10n.finishPrayer,
                          onPressed: _finishPrayer,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: bottomGap),
          ],
        );
      },
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
                    child: Text(
                      '\u{1F4D6}',
                      style: TextStyle(fontSize: emojiSize),
                    ),
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
