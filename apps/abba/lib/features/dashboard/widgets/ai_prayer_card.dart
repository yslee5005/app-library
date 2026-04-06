import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/prayer.dart';
import '../../../providers/providers.dart';
import '../../../services/tts_service.dart';
import '../../../theme/abba_theme.dart';
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
    final tts = ref.watch(ttsServiceProvider);

    return PremiumBlur(
      title: title,
      icon: '🔊',
      isLocked: aiPrayer.isPremium && !isUserPremium,
      onUnlock: onUnlock,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            aiPrayer.text(locale),
            style: AbbaTypography.body,
          ),
          const SizedBox(height: AbbaSpacing.md),
          // Audio player UI
          StreamBuilder<TtsPlaybackState>(
            stream: tts.playbackState,
            initialData: const TtsPlaybackState(),
            builder: (context, snapshot) {
              final state = snapshot.data ?? const TtsPlaybackState();
              final progress = state.duration.inMilliseconds > 0
                  ? state.position.inMilliseconds /
                      state.duration.inMilliseconds
                  : 0.0;

              return Container(
                padding: const EdgeInsets.all(AbbaSpacing.md),
                decoration: BoxDecoration(
                  color: AbbaColors.sage.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AbbaRadius.md),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (state.isPlaying) {
                          tts.pause();
                        } else if (state.position > Duration.zero) {
                          tts.resume();
                        } else {
                          tts.speak(
                            text: aiPrayer.text(locale),
                            voice: ref.read(userProfileProvider).when(
                                  data: (p) => p.voicePreference,
                                  loading: () => 'warm',
                                  error: (e, s) => 'warm',
                                ),
                          );
                        }
                      },
                      child: Icon(
                        state.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        size: 40,
                        color: AbbaColors.sage,
                      ),
                    ),
                    const SizedBox(width: AbbaSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor:
                                  AbbaColors.sage.withValues(alpha: 0.3),
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
                  ],
                ),
              );
            },
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
