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

class RecordingOverlay extends ConsumerStatefulWidget {
  const RecordingOverlay({super.key});

  @override
  ConsumerState<RecordingOverlay> createState() => _RecordingOverlayState();
}

class _RecordingOverlayState extends ConsumerState<RecordingOverlay>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _seconds = 0;
  bool _isPaused = false;
  bool _isTextMode = false;
  final _textController = TextEditingController();
  late AnimationController _pulseController;
  String? _audioFilePath;

  @override
  void initState() {
    super.initState();
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
    _startTimer();
    _startRecording();
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
    _timer?.cancel();
    _pulseController.dispose();
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
                    backgroundColor: AbbaColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AbbaRadius.md),
                    ),
                  ),
                  child: Text(
                    l10n.leaveButton,
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
    final recorder = ref.read(audioRecorderServiceProvider);
    final audioPath = await recorder.stopRecording();

    if (_isTextMode) {
      ref.read(currentTranscriptProvider.notifier).state =
          _textController.text;
      ref.read(currentAudioPathProvider.notifier).state = null;
    } else {
      ref.read(currentAudioPathProvider.notifier).state = audioPath;
      ref.read(currentTranscriptProvider.notifier).state = '';
    }

    prayerLog.info(
      'Recording finished, mode=${_isTextMode ? "text" : "voice"}, '
      'audioPath=$audioPath',
    );

    if (context.mounted) {
      Navigator.of(context).pop();
      context.go('/home/ai-loading');
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
                          final recorder = ref.read(audioRecorderServiceProvider);
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
                      color: AbbaColors.sage,
                    ),
                    label: Text(
                      l10n.switchToText,
                      style: AbbaTypography.bodySmall.copyWith(
                        color: AbbaColors.sage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Waveform or text input
            Expanded(child: SingleChildScrollView(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            const SizedBox(height: AbbaSpacing.xl),
            if (_isTextMode)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.xl),
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
                      borderRadius: BorderRadius.circular(AbbaRadius.lg),
                      borderSide: const BorderSide(color: AbbaColors.sage),
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
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.xl),
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
            ))),
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
                      onPressed: _finishRecording,
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
