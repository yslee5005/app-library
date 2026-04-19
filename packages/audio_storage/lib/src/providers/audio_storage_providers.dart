import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/audio_storage_service.dart';

/// Provider for the audio storage service.
/// Override with a concrete implementation (mock or supabase) at app startup.
final audioStorageServiceProvider = Provider<AudioStorageService>((ref) {
  throw UnimplementedError(
    'audioStorageServiceProvider must be overridden in ProviderScope',
  );
});
