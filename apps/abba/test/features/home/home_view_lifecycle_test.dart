import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wave A fix #3 — App lifecycle background guard.
///
/// While voice-recording is active, transitioning to
/// `AppLifecycleState.paused` MUST stop the recorder immediately. On
/// `resumed`, a recovery dialog with [Restart / Switch to text /
/// Discard] options must appear.
///
/// Driving this end-to-end requires:
///   1. Booting the full HomeView widget tree (blocked by google_fonts
///      HTTP-400 flake — see `recording_overlay_test.dart` header note).
///   2. A real platform-channel for `path_provider.getTemporaryDirectory`
///      (we mock it via `TestDefaultBinaryMessengerBinding`).
///   3. Driving `WidgetsBinding.instance.handleAppLifecycleStateChanged`.
///
/// What we cover here:
///   - The lifecycle dispatch surface the implementation depends on
///     actually exists and accepts the values we pass. This catches
///     a Flutter API rename / removal regression.
///
/// TODO: promote to a HomeView widget test once the google_fonts
/// flake is resolved. The widget test should:
///   1. start a voice prayer session
///   2. drive `AppLifecycleState.paused` → assert tracking recorder
///      stopCount += 1
///   3. drive `AppLifecycleState.resumed` → assert AlertDialog with
///      'Your prayer recording was interrupted' title appears
///   4. tap 'Restart recording' / 'Write as text instead' / discard
///      buttons → assert each branch's expected state
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Lifecycle dispatch surface (Wave A fix #3)', () {
    test('handleAppLifecycleStateChanged accepts paused', () {
      // Smoke test: the API our implementation calls into still exists.
      WidgetsBinding.instance.handleAppLifecycleStateChanged(
        AppLifecycleState.paused,
      );
    });

    test('handleAppLifecycleStateChanged accepts resumed', () {
      WidgetsBinding.instance.handleAppLifecycleStateChanged(
        AppLifecycleState.resumed,
      );
    });

    test('handleAppLifecycleStateChanged accepts inactive + hidden', () {
      WidgetsBinding.instance.handleAppLifecycleStateChanged(
        AppLifecycleState.inactive,
      );
      WidgetsBinding.instance.handleAppLifecycleStateChanged(
        AppLifecycleState.hidden,
      );
    });
  });
}
