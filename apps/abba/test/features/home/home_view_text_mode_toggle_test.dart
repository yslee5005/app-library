import 'package:flutter_test/flutter_test.dart';
import 'package:app_lib_audio_recorder/audio_recorder.dart';

/// Wave A fix #2 — text-mode toggle is destructive while voice is
/// recording. Confirm dialog must appear; cancel = no-op; confirm
/// invokes `recorder.stopRecording`, clears `currentAudioPathProvider`,
/// and disables the toggle (text-only lock).
///
/// Full HomeView widget tests for the destructive-switch flow are
/// blocked by the same google_fonts HTTP-400 flake documented in
/// `recording_overlay_test.dart`. The destructive-switch RecordingOverlay
/// flow IS covered by an end-to-end widget test in that file (see the
/// "destructive confirm dialog" + "cancel keeps voice mode" tests there).
///
/// What we cover here at the unit level:
///   - The MockAudioRecorderService contract that the destructive
///     switch relies on (stopRecording is idempotent, isRecording
///     flag flips, etc.).
///   - The "stop count" tracking pattern used by HomeView's confirmed
///     switch path so a regression in that contract surfaces here.
///
/// TODO: promote to a HomeView widget test once the google_fonts
/// flake is resolved. The widget test should:
///   1. start a prayer session
///   2. tap the keyboard icon → expect AlertDialog with title
///      'Switch to text mode?'
///   3. tap 'Keep recording' → expect no TextField + recorder not stopped
///   4. (separate) tap 'Switch to text' → expect recorder.stopCount += 1
///      + currentAudioPathProvider == null + toggle disabled
class _TrackingRecorder extends MockAudioRecorderService {
  int stopCount = 0;

  @override
  Future<String?> stopRecording() async {
    stopCount += 1;
    return super.stopRecording();
  }
}

void main() {
  group('Destructive switch recorder contract (Wave A fix #2)', () {
    late _TrackingRecorder recorder;

    setUp(() {
      recorder = _TrackingRecorder();
    });

    test('stopRecording increments counter on each call', () async {
      await recorder.startRecording(path: '/tmp/x.m4a');
      expect(recorder.isRecording, isTrue);
      expect(recorder.stopCount, 0);

      final p = await recorder.stopRecording();
      expect(p, '/tmp/x.m4a');
      expect(recorder.stopCount, 1);
      expect(recorder.isRecording, isFalse);
    });

    test('stopRecording without active session is still safe', () async {
      // The destructive switch path may fire stopRecording even if the
      // recorder already stopped (e.g. paused mid-session). Must not
      // throw or corrupt state.
      final p = await recorder.stopRecording();
      expect(p, isNull);
      expect(recorder.stopCount, 1);
    });

    test('repeated start/stop cycles track stopCount accurately', () async {
      for (var i = 0; i < 3; i++) {
        await recorder.startRecording(path: '/tmp/cycle$i.m4a');
        await recorder.stopRecording();
      }
      expect(recorder.stopCount, 3);
    });
  });
}
