import 'package:audio_waveforms/audio_waveforms.dart';

import '../domain/audio_recorder_service.dart';

/// [audio_waveforms]-backed recorder. Exposes the underlying [RecorderController]
/// so that the calling UI can bind an `AudioWaveforms` widget to the same
/// recording session for live visualization.
class RealAudioRecorderService implements AudioRecorderService {
  final RecorderController controller =
      RecorderController()
        ..androidEncoder = AndroidEncoder.aac
        ..androidOutputFormat = AndroidOutputFormat.mpeg4
        ..sampleRate = 44100;

  String? _currentPath;
  bool _isPaused = false;

  @override
  Future<void> startRecording({required String path}) async {
    _currentPath = path;
    _isPaused = false;
    await controller.record(path: path);
  }

  @override
  Future<String?> stopRecording() async {
    _isPaused = false;
    final path = await controller.stop();
    return path ?? _currentPath;
  }

  @override
  Future<void> pauseRecording() async {
    _isPaused = true;
    await controller.pause();
  }

  @override
  Future<void> resumeRecording() async {
    _isPaused = false;
    await controller.record();
  }

  @override
  bool get isRecording => controller.isRecording;

  @override
  bool get isPaused => _isPaused;

  @override
  void dispose() {
    controller.dispose();
  }
}
