/// Audio recording service abstraction.
/// Mock returns a fake file path, Real uses audio_waveforms for recording + waveform.
abstract class AudioRecorderService {
  Future<void> startRecording({required String path});
  Future<String?> stopRecording();
  Future<void> pauseRecording();
  Future<void> resumeRecording();
  bool get isRecording;
  bool get isPaused;
  void dispose();
}
