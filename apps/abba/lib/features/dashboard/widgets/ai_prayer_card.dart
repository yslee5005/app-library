import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/prayer.dart';
import '../../../providers/providers.dart';
import '../../../services/tts_service.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';
import '../../../widgets/premium_blur.dart';

class AiPrayerCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isLocked = aiPrayer.isPremium && !isUserPremium;

    if (isLocked) {
      return PremiumBlur(
        title: title,
        icon: '🔊',
        isLocked: true,
        onUnlock: onUnlock,
        content: const SizedBox.shrink(),
      );
    }

    final tts = ref.watch(ttsServiceProvider);
    final prayerText = aiPrayer.text(locale);

    return ExpandableCard(
      icon: '🙏',
      title: title,
      summary: prayerText,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prayerText,
            style: AbbaTypography.body.copyWith(
              color: AbbaColors.warmBrown,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AbbaSpacing.md),
          // 읽어주기 버튼 (작은 사이즈)
          StreamBuilder<TtsPlaybackState>(
            stream: tts.playbackState,
            initialData: const TtsPlaybackState(),
            builder: (context, snapshot) {
              final state = snapshot.data ?? const TtsPlaybackState();
              final isActive =
                  state.isPlaying || state.position > Duration.zero;

              return Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 36,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            if (state.isPlaying) {
                              tts.pause();
                            } else if (state.position > Duration.zero) {
                              tts.resume();
                            } else {
                              tts.speak(
                                text: prayerText,
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
                            size: 18,
                            color: AbbaColors.sage,
                          ),
                          label: Text(
                            state.isPlaying ? '일시정지' : '읽어주기',
                            style: AbbaTypography.caption.copyWith(
                              color: AbbaColors.sage,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AbbaColors.sage.withValues(alpha: 0.4),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AbbaRadius.xl),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AbbaSpacing.md,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isActive) ...[
                    const SizedBox(height: AbbaSpacing.sm),
                    _buildAudioPlayer(state),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer(TtsPlaybackState state) {
    final progress = state.duration.inMilliseconds > 0
        ? state.position.inMilliseconds / state.duration.inMilliseconds
        : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AbbaSpacing.sm,
        vertical: AbbaSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AbbaColors.sage.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AbbaRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AbbaColors.sage.withValues(alpha: 0.3),
                color: AbbaColors.sage,
                minHeight: 3,
              ),
            ),
          ),
          const SizedBox(width: AbbaSpacing.sm),
          Text(
            '${_formatDuration(state.position)} / ${_formatDuration(state.duration)}',
            style: AbbaTypography.caption,
          ),
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
