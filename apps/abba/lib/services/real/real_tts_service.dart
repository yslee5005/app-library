import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;

import '../../config/app_config.dart';
import 'package:app_lib_logging/logging.dart';
import '../tts_service.dart';

/// Maps voice preference to OpenAI TTS voice
const _voiceMap = {'warm': 'alloy', 'calm': 'nova', 'strong': 'onyx'};

/// Maximum number of cached audio files before cleanup
const _maxCacheEntries = 10;

class RealTtsService implements TtsService {
  final _player = AudioPlayer();
  final _controller = StreamController<TtsPlaybackState>.broadcast();

  /// Cache: textHash -> filePath
  final Map<String, String> _cache = {};

  /// Track insertion order for LRU eviction
  final List<String> _cacheOrder = [];

  RealTtsService() {
    // Forward player state to our stream
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
    final textHash = text.hashCode.toString();
    final openAiVoice = _voiceMap[voice] ?? 'alloy';

    // Check cache
    if (_cache.containsKey(textHash)) {
      final cachedPath = _cache[textHash]!;
      final file = File(cachedPath);
      if (file.existsSync()) {
        await _player.setFilePath(cachedPath);
        await _player.play();
        return;
      } else {
        // Stale cache entry
        _cache.remove(textHash);
        _cacheOrder.remove(textHash);
      }
    }

    ttsLog.info('TTS API call started');

    try {
      // Call OpenAI TTS API
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/audio/speech'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConfig.openAiApiKey}',
        },
        body: jsonEncode({
          'model': 'tts-1',
          'input': text,
          'voice': openAiVoice,
          'response_format': 'mp3',
        }),
      );

      if (response.statusCode != 200) {
        ttsLog.info('TTS API failed: ${response.statusCode}');
        throw Exception('TTS API failed: ${response.statusCode}');
      }

      // Save to temp file
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/abba_tts_$textHash.mp3';
      await File(filePath).writeAsBytes(response.bodyBytes);

      // Manage cache size
      _cache[textHash] = filePath;
      _cacheOrder.add(textHash);
      await _evictOldCacheEntries();

      await _player.setFilePath(filePath);
      await _player.play();
    } catch (e, stackTrace) {
      ttsLog.error('OpenAI TTS failed', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Remove oldest cache entries when exceeding max size
  Future<void> _evictOldCacheEntries() async {
    while (_cacheOrder.length > _maxCacheEntries) {
      final oldest = _cacheOrder.removeAt(0);
      final path = _cache.remove(oldest);
      if (path != null) {
        try {
          final file = File(path);
          if (file.existsSync()) {
            await file.delete();
          }
        } catch (_) {
          // Ignore deletion errors for temp files
        }
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
