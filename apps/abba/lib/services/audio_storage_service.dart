/// Uploads/downloads prayer audio to/from Supabase Storage.
abstract class AudioStorageService {
  /// Upload local audio file → Supabase Storage.
  /// Returns the storage path (e.g., 'abba/{userId}/{prayerId}.m4a').
  Future<String> uploadPrayerAudio({
    required String localPath,
    required String userId,
    required String prayerId,
  });

  /// Get a signed URL for private audio playback (1-hour expiry).
  Future<String> getSignedUrl({required String storagePath});
}
