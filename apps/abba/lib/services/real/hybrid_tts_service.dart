import 'dart:async';

import '../error_logging_service.dart';
import '../tts_service.dart';

/// Orchestrates primary (cloud) and fallback (on-device) TTS services.
/// Swap [primary] to change cloud provider without touching other code.
class HybridTtsService implements TtsService {
  final TtsService primary;
  final TtsService fallback;

  TtsService? _active;

  HybridTtsService({required this.primary, required this.fallback});

  @override
  Future<void> speak({required String text, required String voice}) async {
    try {
      _active = primary;
      await primary.speak(text: text, voice: voice);
    } catch (e) {
      ErrorLoggingService.addBreadcrumb(
        'Primary TTS failed, falling back to on-device: $e',
        category: 'tts',
      );
      _active = fallback;
      await fallback.speak(text: text, voice: voice);
    }
  }

  @override
  Future<void> pause() async {
    await (_active ?? primary).pause();
  }

  @override
  Future<void> resume() async {
    await (_active ?? primary).resume();
  }

  @override
  Future<void> stop() async {
    await (_active ?? primary).stop();
  }

  @override
  Stream<TtsPlaybackState> get playbackState {
    // Merge both streams — only the active one emits during playback
    final controller = StreamController<TtsPlaybackState>.broadcast();
    primary.playbackState.listen(controller.add);
    fallback.playbackState.listen(controller.add);
    return controller.stream;
  }
}
