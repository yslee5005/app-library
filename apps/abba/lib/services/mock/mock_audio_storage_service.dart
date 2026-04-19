import '../audio_storage_service.dart';

class MockAudioStorageService implements AudioStorageService {
  @override
  Future<String> uploadPrayerAudio({
    required String localPath,
    required String userId,
    required String prayerId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return 'abba/$userId/$prayerId.m4a';
  }

  @override
  Future<String> getSignedUrl({required String storagePath}) async {
    return 'https://mock-storage.example.com/$storagePath';
  }
}
