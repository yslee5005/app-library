import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;

import '../../config/app_config.dart';
import 'package:app_lib_logging/logging.dart';
import '../tts_service.dart';

/// Maps voice preference to Google Cloud Neural2 Korean voices
const _voiceMap = {
  'warm': 'ko-KR-Neural2-A',   // 여성 (따뜻한 톤)
  'calm': 'ko-KR-Neural2-B',   // 여성 (차분한 톤)
  'strong': 'ko-KR-Neural2-C', // 남성 (힘있는 톤)
};

const _maxCacheEntries = 10;

class GoogleCloudTtsService implements TtsService {
  final _player = AudioPlayer();
  final _controller = StreamController<TtsPlaybackState>.broadcast();
  final Map<String, String> _cache = {};
  final List<String> _cacheOrder = [];

  GoogleCloudTtsService() {
    _player.positionStream.listen((position) {
      _controller.add(
        TtsPlaybackState(
          position: position,
          duration: _player.duration ?? Duration.zero,
          isPlaying: _player.playing,
        ),
      );
    });
  }

  @override
  Future<void> speak({required String text, required String voice}) async {
    final textHash = '${text.hashCode}_$voice';
    final voiceName = _voiceMap[voice] ?? 'ko-KR-Neural2-A';

    // Check cache
    if (_cache.containsKey(textHash)) {
      final cachedPath = _cache[textHash]!;
      final file = File(cachedPath);
      if (file.existsSync()) {
        await _player.setFilePath(cachedPath);
        await _player.play();
        return;
      } else {
        _cache.remove(textHash);
        _cacheOrder.remove(textHash);
      }
    }

    ttsLog.info('Google Cloud TTS API call started');

    try {
      final response = await http.post(
        Uri.parse(
          'https://texttospeech.googleapis.com/v1/text:synthesize'
          '?key=${AppConfig.googleCloudTtsApiKey}',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'input': {'text': text},
          'voice': {
            'languageCode': 'ko-KR',
            'name': voiceName,
          },
          'audioConfig': {
            'audioEncoding': 'MP3',
            'speakingRate': 0.9, // 기도문은 약간 느리게
            'pitch': 0.0,
          },
        }),
      );

      if (response.statusCode != 200) {
        ttsLog.info('Google Cloud TTS failed: ${response.statusCode}');
        throw Exception('Google Cloud TTS failed: ${response.statusCode}');
      }

      // Google Cloud returns base64-encoded audio in JSON
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final audioBytes = base64Decode(json['audioContent'] as String);

      // Save to temp file
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/abba_gcloud_tts_$textHash.mp3';
      await File(filePath).writeAsBytes(audioBytes);

      // Manage cache
      _cache[textHash] = filePath;
      _cacheOrder.add(textHash);
      await _evictOldCacheEntries();

      await _player.setFilePath(filePath);
      await _player.play();
    } catch (e, stackTrace) {
      ttsLog.error('Google Cloud TTS failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> _evictOldCacheEntries() async {
    while (_cacheOrder.length > _maxCacheEntries) {
      final oldest = _cacheOrder.removeAt(0);
      final path = _cache.remove(oldest);
      if (path != null) {
        try {
          final file = File(path);
          if (file.existsSync()) await file.delete();
        } catch (_) {}
      }
    }
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> resume() => _player.play();

  @override
  Future<void> stop() => _player.stop();

  @override
  Stream<TtsPlaybackState> get playbackState => _controller.stream;
}
