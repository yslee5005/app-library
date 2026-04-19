import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_lib_logging/logging.dart';

import '../audio_storage_service.dart';

class SupabaseAudioStorageService implements AudioStorageService {
  final SupabaseClient _client;
  static const _bucket = 'prayers';

  SupabaseAudioStorageService(this._client);

  @override
  Future<String> uploadPrayerAudio({
    required String localPath,
    required String userId,
    required String prayerId,
  }) async {
    final storagePath = 'abba/$userId/$prayerId.m4a';
    final file = File(localPath);

    apiLog.info('Uploading prayer audio: $storagePath');

    await _client.storage.from(_bucket).upload(
          storagePath,
          file,
          fileOptions: const FileOptions(contentType: 'audio/mp4'),
        );

    apiLog.info('Prayer audio uploaded: $storagePath');
    return storagePath;
  }

  @override
  Future<String> getSignedUrl({required String storagePath}) async {
    final url = await _client.storage.from(_bucket).createSignedUrl(
          storagePath,
          3600, // 1 hour
        );
    return url;
  }
}
