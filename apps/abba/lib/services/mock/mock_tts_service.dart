import 'dart:async';

import '../tts_service.dart';

class MockTtsService implements TtsService {
  final _controller = StreamController<TtsPlaybackState>.broadcast();
  Timer? _playbackTimer;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  static const _mockDuration = Duration(seconds: 45);

  @override
  Future<void> speak({required String text, required String voice}) async {
    _position = Duration.zero;
    _isPlaying = true;
    _emitState();

    _playbackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPlaying) return;
      _position += const Duration(seconds: 1);
      if (_position >= _mockDuration) {
        _isPlaying = false;
        timer.cancel();
      }
      _emitState();
    });
  }

  @override
  Future<void> pause() async {
    _isPlaying = false;
    _emitState();
  }

  @override
  Future<void> resume() async {
    _isPlaying = true;
    _emitState();
  }

  @override
  Future<void> stop() async {
    _isPlaying = false;
    _position = Duration.zero;
    _playbackTimer?.cancel();
    _emitState();
  }

  @override
  Stream<TtsPlaybackState> get playbackState => _controller.stream;

  void _emitState() {
    _controller.add(
      TtsPlaybackState(
        position: _position,
        duration: _mockDuration,
        isPlaying: _isPlaying,
      ),
    );
  }
}
