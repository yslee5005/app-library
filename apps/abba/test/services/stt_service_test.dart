import 'package:flutter_test/flutter_test.dart';
import 'package:abba/services/mock/mock_stt_service.dart';

void main() {
  late MockSttService service;

  setUp(() {
    service = MockSttService();
  });

  group('MockSttService', () {
    test('initialize returns true', () async {
      final result = await service.initialize();
      expect(result, true);
    });

    test('isAvailable is true after init', () async {
      await service.initialize();
      expect(service.isAvailable, true);
    });

    test('startListening sets isListening to true', () async {
      await service.initialize();
      await service.startListening(
        onResult: (text, isFinal) {},
        onError: (error) {},
      );

      expect(service.isListening, true);
    });

    test('stopListening sets isListening to false', () async {
      await service.initialize();
      await service.startListening(
        onResult: (text, isFinal) {},
        onError: (error) {},
      );
      await service.stopListening();

      expect(service.isListening, false);
    });

    test('cancelListening stops listening', () async {
      await service.initialize();
      await service.startListening(
        onResult: (text, isFinal) {},
        onError: (error) {},
      );
      await service.cancelListening();

      expect(service.isListening, false);
    });

    test('setLocale does not throw', () {
      expect(() => service.setLocale('ko_KR'), returnsNormally);
    });
  });
}
