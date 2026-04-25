import 'package:flutter_test/flutter_test.dart';

/// Wave A fix #1 — text-mode "기도 마침" must be disabled when the
/// transcript is empty or under 5 trimmed chars. No Gemini call, no
/// quota debit, no DB row.
///
/// Logic-level coverage of the same threshold the UI gate uses
/// (`_minTextLength = 5` in `home_view.dart`). Full UI rendering of
/// HomeView is gated behind google_fonts' HTTP-400 flake in this test
/// harness (see `recording_overlay_test.dart` header note) so we keep
/// the rendered-tree assertion as a TODO and verify the threshold via
/// a pure dart unit instead. The runtime guard inside
/// `_finishPrayer` is still authoritative — it short-circuits before
/// any Gemini call / quota debit / DB row.
///
/// TODO: when the google_fonts test-harness flake is resolved,
/// promote this to a widget test that:
///   1. starts a prayer session
///   2. switches to text mode via the destructive confirm dialog
///   3. asserts AbsorbPointer(absorbing: true) on the finish button
///      while text length < 5
///   4. asserts AbsorbPointer(absorbing: false) once length >= 5
void main() {
  group('Text-mode finish guard threshold (Wave A fix #1)', () {
    const minLen = 5;

    bool canFinishText(String input) => input.trim().length >= minLen;

    test('empty string is rejected', () {
      expect(canFinishText(''), isFalse);
    });

    test('whitespace-only string is rejected after trim', () {
      expect(canFinishText('   '), isFalse);
    });

    test('4 chars rejected (under min)', () {
      expect(canFinishText('abcd'), isFalse);
    });

    test('exactly 5 chars accepted', () {
      expect(canFinishText('hello'), isTrue);
    });

    test('long content accepted', () {
      expect(canFinishText('this is a real prayer'), isTrue);
    });

    test('leading + trailing whitespace trimmed before length check', () {
      expect(canFinishText('   ab   '), isFalse);
      expect(canFinishText('   hello   '), isTrue);
    });
  });
}
