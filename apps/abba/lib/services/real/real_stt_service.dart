import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../stt_service.dart';

class RealSttService implements SttService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _listening = false;
  String _accumulatedText = '';
  void Function(String, bool)? _onResult;
  void Function(String)? _onError;
  String _localeId = 'en_US';

  @override
  Future<bool> initialize() async {
    return _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening' && _listening) {
          // Auto-restart for 1-min session limit
          _restartListening();
        }
      },
      onError: (error) {
        _onError?.call(error.errorMsg);
      },
    );
  }

  @override
  void setLocale(String localeId) {
    _localeId = localeId;
  }

  @override
  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
    required void Function(String error) onError,
  }) async {
    _listening = true;
    _accumulatedText = '';
    _onResult = onResult;
    _onError = onError;

    await _doListen();
  }

  Future<void> _doListen() async {
    await _speech.listen(
      onResult: (result) {
        final text = _accumulatedText + result.recognizedWords;
        _onResult?.call(text, result.finalResult);
        if (result.finalResult) {
          _accumulatedText = '$text ';
        }
      },
      listenFor: const Duration(seconds: 59),
      pauseFor: const Duration(seconds: 10),
      localeId: _localeId,
      listenOptions: stt.SpeechListenOptions(
        onDevice: true,
        cancelOnError: false,
      ),
    );
  }

  void _restartListening() {
    if (!_listening) return;
    _doListen();
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
