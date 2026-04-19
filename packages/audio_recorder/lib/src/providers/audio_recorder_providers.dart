import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/audio_recorder_service.dart';

/// Provider for the audio recorder service.
/// Override with a concrete implementation (mock or real) at app startup.
final audioRecorderServiceProvider = Provider<AudioRecorderService>((ref) {
  throw UnimplementedError(
    'audioRecorderServiceProvider must be overridden in ProviderScope',
  );
});
