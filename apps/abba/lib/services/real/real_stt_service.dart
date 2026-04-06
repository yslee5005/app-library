import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../stt_service.dart';

class RealSttService implements SttService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _listening = false;
  String _accumulatedText = '';
  void Function(String, bool)? _onResult;

  @override
  Future<bool> initialize() async {
    return _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening' && _listening) {
          _restartListening();
        }
      },
    );
  }

  @override
  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
    required void Function(String error) onError,
  }) async {
    _listening = true;
    _accumulatedText = '';
    _onResult = onResult;

    void handleResult(SpeechRecognitionResult result) {
      final text = _accumulatedText + result.recognizedWords;
      onResult(text, result.finalResult);
    }

    await _speech.listen(
      onResult: handleResult,
      listenFor: const Duration(seconds: 59),
      pauseFor: const Duration(seconds: 10),
      localeId: 'en_US',
      listenOptions: stt.SpeechListenOptions(
        onDevice: true,
        cancelOnError: false,
      ),
    );
  }

  void _restartListening() {
    if (!_listening || _onResult == null) return;

    void handleResult(SpeechRecognitionResult result) {
      final text = _accumulatedText + result.recognizedWords;
      _onResult?.call(text, result.finalResult);
    }

    _speech.listen(
      onResult: handleResult,
      listenFor: const Duration(seconds: 59),
      pauseFor: const Duration(seconds: 10),
      listenOptions: stt.SpeechListenOptions(
        onDevice: true,
        cancelOnError: false,
      ),
    );
  }

  @override
  Future<void> stopListening() async {
    _listening = false;
    await _speech.stop();
  }

  @override
  Future<void> cancelListening() async {
    _listening = false;
    await _speech.cancel();
  }

  @override
  bool get isListening => _speech.isListening;

  @override
  bool get isAvailable => _speech.isAvailable;
}
