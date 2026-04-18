import 'dart:async';

import 'package:app_lib_logging/logging.dart';
import '../tts_service.dart';

/// Orchestrates primary (cloud) and fallback (on-device) TTS services.
/// Swap [primary] to change cloud provider without touching other code.
class HybridTtsService implements TtsService {
  final TtsService primary;
  final TtsService fallback;

  TtsService? _active;
  late final StreamController<TtsPlaybackState> _controller;

  HybridTtsService({required this.primary, required this.fallback}) {
    _controller = StreamController<TtsPlaybackState>.broadcast();
    primary.playbackState.listen(_controller.add);
    fallback.playbackState.listen(_controller.add);
  }

  @override
  Future<void> speak({required String text, required String voice}) async {
    try {
      _active = primary;
      await primary.speak(text: text, voice: voice);
    } catch (e) {
      ttsLog.info('Primary TTS failed, falling back to on-device: $e');
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
  Stream<TtsPlaybackState> get playbackState => _controller.stream;
}
