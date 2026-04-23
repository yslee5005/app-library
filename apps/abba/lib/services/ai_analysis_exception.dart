/// Raised when Gemini prayer/meditation analysis fails. Distinct from the
/// hardcoded fallback pattern used prior to 2026-04-23 — UI callers catch
/// this and show an explicit error view with a retry button, rather than
/// silently substituting canned content that the user mistakes for a real
/// AI response.
///
/// See:
///   apps/abba/specs/REQUIREMENTS.md §11
///   apps/abba/specs/DESIGN.md §10
///   .claude/rules/learned-pitfalls.md §2-1
class AiAnalysisException implements Exception {
  final String message;
  final AiAnalysisFailureKind kind;
  final Object? cause;
  final StackTrace? causeStackTrace;

  const AiAnalysisException(
    this.message, {
    required this.kind,
    this.cause,
    this.causeStackTrace,
  });

  @override
  String toString() => 'AiAnalysisException(${kind.name}): $message'
      '${cause != null ? " — $cause" : ""}';
}

/// Failure category — drives the user-facing error copy.
///
/// `parseError` is internally distinct for diagnostics but rendered to the
/// user identically to `apiError` ("AI 서비스가 불안정해요"). From the user
/// POV, both mean "retry — not your fault".
enum AiAnalysisFailureKind {
  /// Network unavailable (offline, DNS fail, connectivity check).
  network,

  /// Gemini API itself errored (timeout, 5xx, auth, quota).
  apiError,

  /// Gemini returned a response but it was malformed JSON.
  parseError,
}
