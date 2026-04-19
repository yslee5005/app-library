/// Audio recording package — microphone capture via `audio_waveforms`.
///
/// Callers depend on the [AudioRecorderService] interface; wire
/// [RealAudioRecorderService] in production and [MockAudioRecorderService]
/// in tests. `audio_waveforms` is re-exported so consumers can bind
/// the `AudioWaveforms` widget to `RealAudioRecorderService.controller`
/// without importing the native plugin directly.
library;

export 'package:audio_waveforms/audio_waveforms.dart';

export 'src/domain/audio_recorder_service.dart';
export 'src/data/real_audio_recorder_service.dart';
export 'src/data/mock_audio_recorder_service.dart';
export 'src/providers/audio_recorder_providers.dart';
