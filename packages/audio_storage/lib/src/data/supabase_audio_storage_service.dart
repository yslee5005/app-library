import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/audio_storage_service.dart';

/// Supabase Storage-backed implementation.
/// Private bucket + signed URLs; path layout `{userId}/{recordId}.{ext}`
/// to match the RLS policy `auth.uid()::text = (storage.foldername(name))[1]`.
class SupabaseAudioStorageService implements AudioStorageService {
  SupabaseAudioStorageService(this._client, {String bucket = 'audio-prayers'})
    : _bucket = bucket;

  final SupabaseClient _client;
  final String _bucket;

  @override
  Future<String> uploadAudio({
    required String localPath,
    required String userId,
    required String recordId,
    String extension = 'm4a',
  }) async {
    final file = File(localPath);
    if (!file.existsSync()) {
      throw AudioStorageException('Local file does not exist: $localPath');
    }
    final storagePath = '$userId/$recordId.$extension';
    try {
      await _client.storage
          .from(_bucket)
          .upload(
            storagePath,
            file,
            fileOptions: FileOptions(
              contentType: _contentTypeFor(extension),
              upsert: true,
            ),
          );
      return storagePath;
    } catch (e) {
      throw AudioStorageException('Upload failed', cause: e);
    }
  }

  @override
  Future<String> getPlaybackUrl(
    String storagePath, {
    Duration expiresIn = const Duration(hours: 1),
  }) async {
    try {
      return await _client.storage
          .from(_bucket)
          .createSignedUrl(storagePath, expiresIn.inSeconds);
    } catch (e) {
      throw AudioStorageException('Signed URL creation failed', cause: e);
    }
  }

  @override
  Future<void> deleteAudio(String storagePath) async {
    try {
      await _client.storage.from(_bucket).remove([storagePath]);
    } catch (e) {
      throw AudioStorageException('Delete failed', cause: e);
    }
  }

  String _contentTypeFor(String ext) {
    switch (ext.toLowerCase()) {
      case 'm4a':
      case 'aac':
        return 'audio/mp4';
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'ogg':
        return 'audio/ogg';
      default:
        return 'application/octet-stream';
    }
  }
}
