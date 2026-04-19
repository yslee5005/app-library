import '../domain/audio_storage_service.dart';

/// In-memory mock. No network; returns deterministic fake URLs.
class MockAudioStorageService implements AudioStorageService {
  final Map<String, String> _uploaded = {};

  @override
  Future<String> uploadAudio({
    required String localPath,
    required String userId,
    required String recordId,
    String extension = 'm4a',
  }) async {
    final path = '$userId/$recordId.$extension';
    _uploaded[path] = localPath;
    return path;
  }

  @override
  Future<String> getPlaybackUrl(
    String storagePath, {
    Duration expiresIn = const Duration(hours: 1),
  }) async {
    return 'https://mock.storage.local/$storagePath';
  }

  @override
  Future<void> deleteAudio(String storagePath) async {
    _uploaded.remove(storagePath);
  }
}
