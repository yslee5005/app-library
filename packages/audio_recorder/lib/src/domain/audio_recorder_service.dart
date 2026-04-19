/// Audio recording service abstraction.
///
/// Callers supply a local file path on [startRecording]; the implementation
/// writes the captured audio there. [stopRecording] returns the same path
/// (or `null` if no recording was active). Mock and real implementations
/// live in `data/`.
abstract class AudioRecorderService {
  Future<void> startRecording({required String path});
  Future<String?> stopRecording();
  Future<void> pauseRecording();
  Future<void> resumeRecording();
  bool get isRecording;
  bool get isPaused;
  void dispose();
}
