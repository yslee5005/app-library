import 'dart:async';

import '../stt_service.dart';

class MockSttService implements SttService {
  bool _listening = false;
  bool _available = true;
  Timer? _simulationTimer;

  static const _mockTranscripts = [
    'Dear Lord, ',
    'Dear Lord, I thank you ',
    'Dear Lord, I thank you for this beautiful morning. ',
    'Dear Lord, I thank you for this beautiful morning. Please guide my steps today ',
    'Dear Lord, I thank you for this beautiful morning. Please guide my steps today and help me to be a blessing to others.',
  ];

  @override
  Future<bool> initialize() async {
    _available = true;
    return true;
  }

  @override
  void setLocale(String localeId) {
    // No-op for mock
  }

  @override
  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
    required void Function(String error) onError,
  }) async {
    _listening = true;
    int index = 0;

    _simulationTimer =
        Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (!_listening || index >= _mockTranscripts.length) {
        timer.cancel();
        if (index >= _mockTranscripts.length) {
          onResult(_mockTranscripts.last, true);
        }
        return;
      }
      final isFinal = index == _mockTranscripts.length - 1;
      onResult(_mockTranscripts[index], isFinal);
      index++;
    });
  }

  @override
  Future<void> stopListening() async {
    _listening = false;
    _simulationTimer?.cancel();
  }

  @override
  Future<void> cancelListening() async {
    _listening = false;
    _simulationTimer?.cancel();
  }

  @override
  bool get isListening => _listening;

  @override
  bool get isAvailable => _available;
}
