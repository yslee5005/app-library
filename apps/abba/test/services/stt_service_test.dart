import 'package:flutter_test/flutter_test.dart';
import 'package:abba/services/mock/mock_audio_recorder_service.dart';

void main() {
  late MockAudioRecorderService service;

  setUp(() {
    service = MockAudioRecorderService();
  });

  group('MockAudioRecorderService', () {
    test('startRecording sets isRecording to true', () async {
      await service.startRecording(path: '/tmp/test.m4a');
      expect(service.isRecording, true);
    });

    test('stopRecording returns file path', () async {
      await service.startRecording(path: '/tmp/test.m4a');
      final path = await service.stopRecording();
      expect(path, '/tmp/test.m4a');
      expect(service.isRecording, false);
    });

    test('pauseRecording sets isPaused to true', () async {
      await service.startRecording(path: '/tmp/test.m4a');
      await service.pauseRecording();
      expect(service.isPaused, true);
    });

    test('resumeRecording sets isPaused to false', () async {
      await service.startRecording(path: '/tmp/test.m4a');
      await service.pauseRecording();
      await service.resumeRecording();
      expect(service.isPaused, false);
    });

    test('dispose does not throw', () {
      expect(() => service.dispose(), returnsNormally);
    });
  });
}
