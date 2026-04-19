import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:app_lib_logging/logging.dart';

import '../theme/abba_theme.dart';

/// Reusable audio player with waveform visualization.
/// Used in testimony card, calendar, and prayer history.
class PrayerPlayer extends StatefulWidget {
  final String audioUrl;

  const PrayerPlayer({super.key, required this.audioUrl});

  @override
  State<PrayerPlayer> createState() => _PrayerPlayerState();
}

class _PrayerPlayerState extends State<PrayerPlayer> {
  late final PlayerController _controller;
  bool _isPlaying = false;
  bool _prepared = false;
  double _speed = 1.0;

  static const _speeds = [0.5, 1.0, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _controller = PlayerController();
    _prepare();
  }

  Future<void> _prepare() async {
    try {
      await _controller.preparePlayer(
        path: widget.audioUrl,
        shouldExtractWaveform: true,
      );
      _controller.onCompletion.listen((_) {
        if (mounted) setState(() => _isPlaying = false);
      });
      if (mounted) setState(() => _prepared = true);
    } catch (e) {
      prayerLog.warning('Audio player prepare failed', error: e);
    }
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _controller.pausePlayer();
    } else {
      await _controller.startPlayer();
    }
    if (mounted) setState(() => _isPlaying = !_isPlaying);
  }

  void _cycleSpeed() {
    final idx = _speeds.indexOf(_speed);
    final next = _speeds[(idx + 1) % _speeds.length];
    _controller.setRate(next);
    setState(() => _speed = next);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_prepared) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AbbaSpacing.sm),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AbbaColors.sage.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(width: AbbaSpacing.sm),
            Text(
              '로딩 중...',
              style: AbbaTypography.caption.copyWith(color: AbbaColors.muted),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AbbaSpacing.sm),
      decoration: BoxDecoration(
        color: AbbaColors.sage.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AbbaRadius.md),
      ),
      child: Row(
        children: [
          // Play/Pause button
          GestureDetector(
            onTap: _togglePlay,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AbbaColors.sage,
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: AbbaColors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: AbbaSpacing.sm),
          // Waveform
          Expanded(
            child: AudioFileWaveforms(
              size: const Size(double.infinity, 40),
              playerController: _controller,
              enableSeekGesture: true,
              playerWaveStyle: PlayerWaveStyle(
                fixedWaveColor: AbbaColors.sage.withValues(alpha: 0.25),
                liveWaveColor: AbbaColors.sage,
                seekLineColor: AbbaColors.sageDark,
                seekLineThickness: 2,
                waveThickness: 2.5,
                spacing: 5,
              ),
            ),
          ),
          const SizedBox(width: AbbaSpacing.sm),
          // Speed button
          GestureDetector(
            onTap: _cycleSpeed,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AbbaSpacing.sm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AbbaColors.sage.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(AbbaRadius.sm),
              ),
              child: Text(
                '${_speed}x',
                style: AbbaTypography.caption.copyWith(
                  color: AbbaColors.sage,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
