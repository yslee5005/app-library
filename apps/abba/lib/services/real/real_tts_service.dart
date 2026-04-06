import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;

import '../../config/app_config.dart';
import '../tts_service.dart';

/// Maps voice preference to OpenAI TTS voice
const _voiceMap = {
  'warm': 'alloy',
  'calm': 'nova',
  'strong': 'onyx',
};

class RealTtsService implements TtsService {
  final _player = AudioPlayer();
  final _controller = StreamController<TtsPlaybackState>.broadcast();
  String? _cachedAudioPath;
  String? _cachedTextHash;

  RealTtsService() {
    // Forward player state to our stream
    _player.positionStream.listen((position) {
      _controller.add(TtsPlaybackState(
        position: position,
        duration: _player.duration ?? Duration.zero,
        isPlaying: _player.playing,
      ));
    });
  }

  @override
  Future<void> speak({
    required String text,
    required String voice,
  }) async {
    final textHash = text.hashCode.toString();
    final openAiVoice = _voiceMap[voice] ?? 'alloy';

    // Check cache
    if (_cachedTextHash == textHash && _cachedAudioPath != null) {
      final file = File(_cachedAudioPath!);
      if (file.existsSync()) {
        await _player.setFilePath(_cachedAudioPath!);
        await _player.play();
        return;
      }
    }

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
      throw Exception('TTS API failed: ${response.statusCode}');
    }

    // Save to temp file
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/abba_tts_$textHash.mp3';
    await File(filePath).writeAsBytes(response.bodyBytes);

    _cachedAudioPath = filePath;
    _cachedTextHash = textHash;

    await _player.setFilePath(filePath);
    await _player.play();
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
