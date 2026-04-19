import '../domain/audio_recorder_service.dart';

/// Mock recorder for tests and dev without a mic.
class MockAudioRecorderService implements AudioRecorderService {
  bool _recording = false;
  bool _paused = false;
  String? _path;

  @override
  Future<void> startRecording({required String path}) async {
    _path = path;
    _recording = true;
    _paused = false;
  }

  @override
  Future<String?> stopRecording() async {
    _recording = false;
    _paused = false;
    return _path;
  }

  @override
  Future<void> pauseRecording() async {
    _paused = true;
  }

  @override
  Future<void> resumeRecording() async {
    _paused = false;
  }

  @override
  bool get isRecording => _recording;

  @override
  bool get isPaused => _paused;

  @override
  void dispose() {}
}
