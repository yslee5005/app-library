/// Text-to-speech service abstraction
/// Mock simulates playback, Real calls OpenAI TTS API + just_audio
abstract class TtsService {
  /// Generate and play TTS audio for the given text
  Future<void> speak({
    required String text,
    required String voice, // 'warm' | 'calm' | 'strong'
  });

  Future<void> pause();
  Future<void> resume();
  Future<void> stop();

  /// Playback state stream: position, duration, isPlaying
  Stream<TtsPlaybackState> get playbackState;
}

class TtsPlaybackState {
  final Duration position;
  final Duration duration;
  final bool isPlaying;

  const TtsPlaybackState({
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isPlaying = false,
  });
}
