import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

import '../tts_service.dart';

class OnDeviceTtsService implements TtsService {
  final _tts = FlutterTts();
  final _controller = StreamController<TtsPlaybackState>.broadcast();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _estimatedDuration = Duration.zero;
  Timer? _positionTimer;

  OnDeviceTtsService() {
    _init();
  }

  Future<void> _init() async {
    await _tts.setLanguage('ko-KR');
    await _tts.setSpeechRate(0.45); // 기도문에 적합한 느린 속도
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _tts.setStartHandler(() {
      _isPlaying = true;
      _position = Duration.zero;
      _startPositionTimer();
      _emitState();
    });

    _tts.setCompletionHandler(() {
      _isPlaying = false;
      _stopPositionTimer();
      _position = _estimatedDuration;
      _emitState();
    });

    _tts.setCancelHandler(() {
      _isPlaying = false;
      _stopPositionTimer();
      _position = Duration.zero;
      _emitState();
    });

    _tts.setPauseHandler(() {
      _isPlaying = false;
      _stopPositionTimer();
      _emitState();
    });

    _tts.setContinueHandler(() {
      _isPlaying = true;
      _startPositionTimer();
      _emitState();
    });
  }

  @override
  Future<void> speak({required String text, required String voice}) async {
    // 한국어 기준: 초당 약 3~4글자 읽기 속도 (느린 기도문 기준)
    final seconds = (text.length / 3.5).ceil();
    _estimatedDuration = Duration(seconds: seconds);
    _position = Duration.zero;

    await _tts.speak(text);
  }

  @override
  Future<void> pause() async {
    await _tts.pause();
  }

  @override
  Future<void> resume() async {
    // flutter_tts does not have a dedicated resume method.
    // Re-speaking is not ideal but is the only reliable cross-platform approach.
    // On iOS, pause/continue works natively via the setContinueHandler.
    _isPlaying = true;
    _startPositionTimer();
    _emitState();
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
    _isPlaying = false;
    _stopPositionTimer();
    _position = Duration.zero;
    _emitState();
  }

  @override
  Stream<TtsPlaybackState> get playbackState => _controller.stream;

  void _startPositionTimer() {
    _stopPositionTimer();
    _positionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPlaying) return;
      _position += const Duration(seconds: 1);
      if (_position >= _estimatedDuration) {
        _position = _estimatedDuration;
      }
      _emitState();
    });
  }

  void _stopPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = null;
  }

  void _emitState() {
    _controller.add(
      TtsPlaybackState(
        position: _position,
        duration: _estimatedDuration,
        isPlaying: _isPlaying,
      ),
    );
  }
}
