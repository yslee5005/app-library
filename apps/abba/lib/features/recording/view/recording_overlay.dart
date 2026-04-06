import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/providers.dart';
import '../../../services/error_logging_service.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_button.dart';
import '../../../widgets/abba_snackbar.dart';

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
  String _transcript = '';
  final _textController = TextEditingController();
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    ErrorLoggingService.addBreadcrumb(
      'Recording started',
      category: 'recording',
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    // Respect reduced motion accessibility setting
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reduceMotion = MediaQuery.of(context).disableAnimations;
      if (!reduceMotion) {
        _pulseController.repeat(reverse: true);
      }
    });
    _startTimer();
    _startStt();
  }

  void _startStt() {
    final stt = ref.read(sttServiceProvider);
    final locale = ref.read(localeProvider);
    stt.initialize().then((_) {
      final sttLocale = switch (locale) {
        'ko' => 'ko_KR',
        'ja' => 'ja_JP',
        'es' => 'es_ES',
        'zh' => 'zh_CN',
        _ => 'en_US',
      };
      stt.setLocale(sttLocale);
      stt.startListening(
        onResult: (text, isFinal) {
          setState(() => _transcript = text);
        },
        onError: (error) {
          // Fallback: switch to text mode on STT error
          setState(() => _isTextMode = true);
          if (mounted) {
            final l10n = AppLocalizations.of(context);
            showAbbaSnackBar(
              context,
              message: l10n?.errorSttFailed ?? 'Voice recognition unavailable.',
            );
          }
        },
      );
    });
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
    ref.read(sttServiceProvider).stopListening();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
    if (_isPaused) {
      _pulseController.stop();
      ref.read(sttServiceProvider).stopListening();
    } else {
      _pulseController.repeat(reverse: true);
      _startStt();
    }
  }

  void _finishRecording() {
    ErrorLoggingService.addBreadcrumb(
      'Recording finished',
      category: 'recording',
    );

    final transcript =
        _isTextMode ? _textController.text : _transcript;
    ref.read(sttServiceProvider).stopListening();

    // Store transcript for AI processing
    ref.read(currentTranscriptProvider.notifier).state = transcript;

    Navigator.of(context).pop();
    context.go('/home/ai-loading');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: AbbaColors.cream,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AbbaRadius.xl)),
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
                    label: 'Close recording',
                    button: true,
                    child: IconButton(
                      onPressed: () {
                        ref.read(sttServiceProvider).cancelListening();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close, size: 28),
                      color: AbbaColors.warmBrown,
                    ),
                  ),
                  Text(l10n.recordingTitle, style: AbbaTypography.h2),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _isTextMode = !_isTextMode);
                      if (_isTextMode) {
                        ref.read(sttServiceProvider).stopListening();
                        _textController.text = _transcript;
                      } else {
                        _startStt();
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
            const Spacer(),
            // Pulse animation or text input
            if (_isTextMode)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AbbaSpacing.xl),
                child: TextField(
                  controller: _textController,
                  maxLines: 8,
                  style: AbbaTypography.body,
                  decoration: InputDecoration(
                    hintText: l10n.textInputHint,
                    hintStyle: AbbaTypography.body
                        .copyWith(color: AbbaColors.muted),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AbbaRadius.lg),
                      borderSide:
                          const BorderSide(color: AbbaColors.sage),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AbbaRadius.lg),
                      borderSide: const BorderSide(
                          color: AbbaColors.sage, width: 2),
                    ),
                    filled: true,
                    fillColor: AbbaColors.white,
                    contentPadding:
                        const EdgeInsets.all(AbbaSpacing.md),
                  ),
                ),
              )
            else
              Column(
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final scale =
                          1.0 + (_pulseController.value * 0.15);
                      return Transform.scale(
                        scale: _isPaused ? 1.0 : scale,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AbbaColors.sage.withValues(
                              alpha: 0.2 +
                                  (_pulseController.value * 0.15),
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
                  ),
                  if (_transcript.isNotEmpty) ...[
                    const SizedBox(height: AbbaSpacing.lg),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AbbaSpacing.xl),
                      child: Text(
                        _transcript,
                        style: AbbaTypography.bodySmall.copyWith(
                          color: AbbaColors.muted,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            const SizedBox(height: AbbaSpacing.xl),
            // Timer
            Text(
              _formattedTime,
              style: AbbaTypography.hero.copyWith(fontSize: 36),
            ),
            const Spacer(),
            // Buttons
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AbbaSpacing.xl),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: abbaButtonHeight,
                      child: OutlinedButton.icon(
                        onPressed: _togglePause,
                        icon: Icon(
                          _isPaused
                              ? Icons.play_arrow
                              : Icons.pause,
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
                          side: const BorderSide(
                              color: AbbaColors.sage),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AbbaRadius.lg),
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
    );
  }
}
