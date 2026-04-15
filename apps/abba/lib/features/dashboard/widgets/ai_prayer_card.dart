import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/prayer.dart';
import '../../../providers/providers.dart';
import '../../../services/tts_service.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/premium_blur.dart';

class AiPrayerCard extends ConsumerStatefulWidget {
  final AiPrayer aiPrayer;
  final String title;
  final String locale;
  final VoidCallback onUnlock;
  final bool isUserPremium;

  const AiPrayerCard({
    super.key,
    required this.aiPrayer,
    required this.title,
    required this.locale,
    required this.onUnlock,
    this.isUserPremium = false,
  });

  @override
  ConsumerState<AiPrayerCard> createState() => _AiPrayerCardState();
}

class _AiPrayerCardState extends ConsumerState<AiPrayerCard> {
  bool _showText = false;

  @override
  Widget build(BuildContext context) {
    final tts = ref.watch(ttsServiceProvider);

    return PremiumBlur(
      title: widget.title,
      icon: '🔊',
      isLocked: widget.aiPrayer.isPremium && !widget.isUserPremium,
      onUnlock: widget.onUnlock,
      content: StreamBuilder<TtsPlaybackState>(
        stream: tts.playbackState,
        initialData: const TtsPlaybackState(),
        builder: (context, snapshot) {
          final state = snapshot.data ?? const TtsPlaybackState();
          final isActive = state.isPlaying || state.position > Duration.zero;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buttons row: 읽어주기 (large) + 내용보기 icon (small)
              Row(
                children: [
                  // 읽어주기 button — prominent
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (state.isPlaying) {
                            tts.pause();
                          } else if (state.position > Duration.zero) {
                            tts.resume();
                          } else {
                            tts.speak(
                              text: widget.aiPrayer.text(widget.locale),
                              voice: ref
                                  .read(userProfileProvider)
                                  .when(
                                    data: (p) => p.voicePreference,
                                    loading: () => 'warm',
                                    error: (e, s) => 'warm',
                                  ),
                            );
                          }
                        },
                        icon: Icon(
                          state.isPlaying ? Icons.pause : Icons.volume_up,
                          size: 22,
                        ),
                        label: Text(
                          state.isPlaying ? '일시정지' : '읽어주기',
                          style: AbbaTypography.body.copyWith(
                            color: AbbaColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AbbaColors.sage,
                          foregroundColor: AbbaColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AbbaRadius.md),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AbbaSpacing.sm),
                  // 내용보기 icon button — compact
                  Container(
                    decoration: BoxDecoration(
                      color: AbbaColors.sage.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AbbaRadius.md),
                    ),
                    child: IconButton(
                      onPressed: () => setState(() => _showText = !_showText),
                      icon: Icon(
                        _showText
                            ? Icons.visibility_off_outlined
                            : Icons.article_outlined,
                        color: AbbaColors.sage,
                      ),
                      tooltip: _showText ? '내용 숨기기' : '내용보기',
                      iconSize: 24,
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                    ),
                  ),
                ],
              ),
              // Audio progress — visible when TTS is active
              if (isActive) ...[
                const SizedBox(height: AbbaSpacing.md),
                _buildAudioPlayer(state),
              ],
              // Text content — toggle
              if (_showText) ...[
                const SizedBox(height: AbbaSpacing.md),
                Text(
                  widget.aiPrayer.text(widget.locale),
                  style: AbbaTypography.body.copyWith(
                    color: AbbaColors.warmBrown,
                    height: 1.6,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildAudioPlayer(TtsPlaybackState state) {
    final progress = state.duration.inMilliseconds > 0
        ? state.position.inMilliseconds / state.duration.inMilliseconds
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(AbbaSpacing.sm),
      decoration: BoxDecoration(
        color: AbbaColors.sage.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AbbaRadius.md),
      ),
      child: Row(
        children: [
          const SizedBox(width: AbbaSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AbbaColors.sage.withValues(alpha: 0.3),
                    color: AbbaColors.sage,
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: AbbaSpacing.xs),
                Text(
                  '${_formatDuration(state.position)} / ${_formatDuration(state.duration)}',
                  style: AbbaTypography.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: AbbaSpacing.sm),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.toString();
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
