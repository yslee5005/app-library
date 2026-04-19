/// Interface for audio file storage (upload + playback URL).
///
/// Implementations typically back onto Supabase Storage. The returned
/// storage path is what callers persist in their DB; playback must go
/// through [getPlaybackUrl] so signed URLs remain short-lived.
abstract class AudioStorageService {
  /// Upload a local audio file to remote storage.
  /// Returns the storage path (e.g. `"{userId}/{recordId}.m4a"`).
  Future<String> uploadAudio({
    required String localPath,
    required String userId,
    required String recordId,
    String extension = 'm4a',
  });

  /// Generate a signed URL for playback. Default expiry: 1 hour.
  Future<String> getPlaybackUrl(
    String storagePath, {
    Duration expiresIn = const Duration(hours: 1),
  });

  /// Permanently delete the file at [storagePath].
  Future<void> deleteAudio(String storagePath);
}

class AudioStorageException implements Exception {
  const AudioStorageException(this.message, {this.cause});
  final String message;
  final Object? cause;

  @override
  String toString() =>
      'AudioStorageException: $message${cause != null ? ' (cause: $cause)' : ''}';
}
