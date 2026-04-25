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

class RecordingOverlay extends ConsumerStatefulWidget {
  const RecordingOverlay({super.key});

  @override
  ConsumerState<RecordingOverlay> createState() => _RecordingOverlayState();
}

class _RecordingOverlayState extends ConsumerState<RecordingOverlay>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Timer? _timer;
  int _seconds = 0;
  bool _isPaused = false;
  bool _isTextMode = false;
  // Wave A fix #2 — locks the session text-only after destructive switch.
  bool _textOnlyLocked = false;
  // Wave A fix #3 — set when the OS suspends mid voice-recording.
  bool _interruptedDuringPause = false;
  final _textController = TextEditingController();
  late AnimationController _pulseController;
  String? _audioFilePath;

  /// Wave A fix #1 — minimum text length to send a text-mode meditation.
  static const int _minTextLength = 5;

  bool get _canFinish {
    if (!_isTextMode) return true;
    return _textController.text.trim().length >= _minTextLength;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future(() {
      ref.read(isRecordingProvider.notifier).state = true;
    });
    prayerLog.info('Recording overlay started');
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reduceMotion = MediaQuery.of(context).disableAnimations;
      if (!reduceMotion) {
        _pulseController.repeat(reverse: true);
      }
    });
    _textController.addListener(_onTextChanged);
    _startTimer();
    _startRecording();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Wave A fix #3 — App lifecycle background guard. Voice mode only.
    if (_isTextMode) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      if (!_interruptedDuringPause) {
        _interruptedDuringPause = true;
        _timer?.cancel();
        _pulseController.stop();
        final recorder = ref.read(audioRecorderServiceProvider);
        recorder.stopRecording().catchError((Object e, StackTrace st) {
          prayerLog.warning('stopRecording on pause failed: $e');
          return null;
        });
        prayerLog.info(
          'Recording overlay auto-stopped due to app lifecycle pause',
        );
      }
    } else if (state == AppLifecycleState.resumed &&
        _interruptedDuringPause &&
        mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showInterruptedDialog();
      });
    }
  }

  Future<void> _startRecording() async {
    final dir = await getTemporaryDirectory();
    _audioFilePath =
        '${dir.path}/prayer_${DateTime.now().millisecondsSinceEpoch}.m4a';
    final recorder = ref.read(audioRecorderServiceProvider);
    await recorder.startRecording(path: _audioFilePath!);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() => _seconds++);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _pulseController.dispose();
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    ref.read(isRecordingProvider.notifier).state = false;
    super.dispose();
  }

  Future<bool> _confirmLeave() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AbbaRadius.lg),
        ),
        title: Text(
          l10n.leaveRecordingTitle,
          style: AbbaTypography.h2,
          textAlign: TextAlign.center,
        ),
        content: Text(
          l10n.leaveRecordingMessage,
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
                    backgroundColor: AbbaColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AbbaRadius.md),
                    ),
                  ),
                  child: Text(
                    l10n.leaveButton,
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
                    l10n.stayButton,
                    style: AbbaTypography.body.copyWith(color: AbbaColors.sage),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  String get _formattedTime {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
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

  Future<void> _finishRecording() async {
    final l10n = AppLocalizations.of(context)!;
    // Wave A fix #1 — block too-short text-mode submissions.
    if (_isTextMode &&
        _textController.text.trim().length < _minTextLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.prayerTooShort)),
      );
      return;
    }
    final recorder = ref.read(audioRecorderServiceProvider);
    final audioPath = await recorder.stopRecording();

    if (_isTextMode) {
      ref.read(currentTranscriptProvider.notifier).state = _textController.text;
      ref.read(currentAudioPathProvider.notifier).state = null;
    } else {
      ref.read(currentAudioPathProvider.notifier).state = audioPath;
      ref.read(currentTranscriptProvider.notifier).state = '';
    }

    prayerLog.info(
      'Recording finished, mode=${_isTextMode ? "text" : "voice"}, '
      'audioPath=$audioPath',
    );

    if (!mounted) return;
    Navigator.of(context).pop();
    context.go('/home/ai-loading');
  }

  /// Wave A fix #2 — destructive switch from voice → text.
  Future<void> _onToggleTextMode() async {
    final l10n = AppLocalizations.of(context)!;
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

    final recorder = ref.read(audioRecorderServiceProvider);
    try {
      await recorder.stopRecording();
    } catch (e) {
      prayerLog.warning('stopRecording during destructive switch failed: $e');
    }
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
    prayerLog.info('Destructively switched overlay to text-only');
  }

  /// Wave A fix #3 — recording interrupted recovery dialog.
  Future<void> _showInterruptedDialog() async {
    if (!mounted) return;
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

    switch (choice) {
      case 'restart':
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
          if (_timer == null || !_timer!.isActive) {
            _startTimer();
          }
          prayerLog.info('Overlay recording restarted after interrupt');
        } catch (e) {
          prayerLog.warning('Failed to restart overlay recording: $e');
          if (!mounted) return;
          Navigator.of(context).pop();
        }
        break;
      case 'text':
        ref.read(currentAudioPathProvider.notifier).state = null;
        setState(() {
          _isTextMode = true;
          _textOnlyLocked = true;
          _isPaused = false;
          _audioFilePath = null;
        });
        if (_timer == null || !_timer!.isActive) _startTimer();
        prayerLog.info('Overlay switched to text-only after interrupt');
        break;
      case 'discard':
      default:
        ref.read(currentAudioPathProvider.notifier).state = null;
        if (mounted) Navigator.of(context).pop();
        prayerLog.info('Overlay session discarded after interrupt');
        break;
    }
  }

  Widget _buildWaveformOrPulse() {
    final recorder = ref.read(audioRecorderServiceProvider);

    if (recorder is RealAudioRecorderService) {
      return Column(
        children: [
          Icon(
            _isPaused ? Icons.pause_circle_outline : Icons.mic,
            size: 48,
            color: AbbaColors.sage,
          ),
          const SizedBox(height: AbbaSpacing.md),
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
      );
    }

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.15);
        return Transform.scale(
          scale: _isPaused ? 1.0 : scale,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AbbaColors.sage.withValues(
                alpha: 0.2 + (_pulseController.value * 0.15),
              ),
            ),
            child: Center(
              child: Container(
                width: 120,
                height: 120,
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmLeave()) {
          final recorder = ref.read(audioRecorderServiceProvider);
          await recorder.stopRecording();
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: AbbaColors.cream,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AbbaRadius.xl),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AbbaSpacing.md,
                  vertical: AbbaSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Semantics(
                      label: l10n.closeRecording,
                      button: true,
                      child: IconButton(
                        onPressed: () async {
                          if (await _confirmLeave()) {
                            final recorder = ref.read(
                              audioRecorderServiceProvider,
                            );
                            await recorder.stopRecording();
                            if (context.mounted) Navigator.of(context).pop();
                          }
                        },
                        icon: const Icon(Icons.close, size: 28),
                        color: AbbaColors.warmBrown,
                      ),
                    ),
                    Text(l10n.recordingTitle, style: AbbaTypography.h2),
                    TextButton.icon(
                      // Wave A fix #2 — destructive voice→text switch.
                      onPressed: _textOnlyLocked
                          ? null
                          : () => _onToggleTextMode(),
                      icon: Icon(
                        _isTextMode ? Icons.mic : Icons.keyboard,
                        color: _textOnlyLocked
                            ? AbbaColors.muted
                            : AbbaColors.sage,
                      ),
                      label: Text(
                        l10n.switchToText,
                        style: AbbaTypography.bodySmall.copyWith(
                          color: _textOnlyLocked
                              ? AbbaColors.muted
                              : AbbaColors.sage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Waveform or text input
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: AbbaSpacing.xl),
                      if (_isTextMode)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AbbaSpacing.xl,
                          ),
                          child: TextField(
                            controller: _textController,
                            maxLines: 8,
                            style: AbbaTypography.body,
                            decoration: InputDecoration(
                              hintText: l10n.textInputHint,
                              hintStyle: AbbaTypography.body.copyWith(
                                color: AbbaColors.muted,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AbbaRadius.lg,
                                ),
                                borderSide: const BorderSide(
                                  color: AbbaColors.sage,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AbbaRadius.lg,
                                ),
                                borderSide: const BorderSide(
                                  color: AbbaColors.sage,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: AbbaColors.white,
                              contentPadding: const EdgeInsets.all(
                                AbbaSpacing.md,
                              ),
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AbbaSpacing.xl,
                          ),
                          child: _buildWaveformOrPulse(),
                        ),
                      const SizedBox(height: AbbaSpacing.xl),
                      // Timer
                      Text(
                        _formattedTime,
                        style: AbbaTypography.hero.copyWith(fontSize: 36),
                      ),
                      const SizedBox(height: AbbaSpacing.xl),
                    ],
                  ),
                ),
              ),
              // Buttons
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
                            _isPaused
                                ? l10n.recordingResume
                                : l10n.recordingPause,
                            style: AbbaTypography.body.copyWith(
                              color: AbbaColors.sage,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AbbaColors.sage),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AbbaRadius.lg,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AbbaSpacing.md),
                    Expanded(
                      // Wave A fix #1 — visually disable finish when
                      // text-mode input is empty / under min length.
                      child: Opacity(
                        opacity: _canFinish ? 1.0 : 0.4,
                        child: AbsorbPointer(
                          absorbing: !_canFinish,
                          child: AbbaButton(
                            label: l10n.finishPrayer,
                            onPressed: _finishRecording,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AbbaSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
