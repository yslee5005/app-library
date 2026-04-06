/// Speech-to-text service abstraction
/// Mock returns preset text after delay, Real uses on-device speech recognition
abstract class SttService {
  Future<bool> initialize();
  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
    required void Function(String error) onError,
  });
  Future<void> stopListening();
  Future<void> cancelListening();
  bool get isListening;
  bool get isAvailable;
}
