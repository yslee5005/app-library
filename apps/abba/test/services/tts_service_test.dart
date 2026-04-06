import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:abba/services/mock/mock_tts_service.dart';
import 'package:abba/services/tts_service.dart';

void main() {
  late MockTtsService service;

  setUp(() {
    service = MockTtsService();
  });

  group('MockTtsService', () {
    test('speak emits playing state', () async {
      // Subscribe before speak so we catch the first emission
      final completer = Completer<TtsPlaybackState>();
      final sub = service.playbackState.listen((state) {
        if (!completer.isCompleted) completer.complete(state);
      });

      await service.speak(text: 'Hello world', voice: 'warm');

      final state = await completer.future.timeout(const Duration(seconds: 5));
      expect(state.isPlaying, true);

      await service.stop();
      await sub.cancel();
    });

    test('stop emits stopped state', () async {
      final states = <TtsPlaybackState>[];
      final sub = service.playbackState.listen(states.add);

      await service.speak(text: 'Hello', voice: 'calm');
      // Wait for first emission
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await service.stop();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(states.last.isPlaying, false);

      await sub.cancel();
    });

    test('pause emits paused state', () async {
      final states = <TtsPlaybackState>[];
      final sub = service.playbackState.listen(states.add);

      await service.speak(text: 'Hello', voice: 'strong');
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await service.pause();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(states.last.isPlaying, false);

      await service.stop();
      await sub.cancel();
    });
  });

  group('TtsPlaybackState', () {
    test('default values', () {
      const state = TtsPlaybackState();
      expect(state.position, Duration.zero);
      expect(state.duration, Duration.zero);
      expect(state.isPlaying, false);
    });
  });
}
