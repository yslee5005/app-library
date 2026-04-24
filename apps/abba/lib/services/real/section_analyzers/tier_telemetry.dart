import 'package:app_lib_logging/logging.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Phase 4.1 — structured telemetry for Gemini tier calls.
///
/// Emitted as `apiLog.info` so Sentry captures the line as an info
/// breadcrumb on production builds. Accumulated over 2-4 weeks this lets
/// us tune the output-token ceiling (spec §Phase 2 "Output token tuning
/// 2000 → 1400") without guessing — we see the real p95 / max.
///
/// Log schema (pipe-separated for easy grep / Sentry search):
///   `[Tier-Usage] tier=t1 locale=ko model=gemini-2.5-flash input=412 output=318 total=730 cached=0`
void logTierUsage({
  required GenerateContentResponse response,
  required String tier,
  required String locale,
  required String model,
  String? note,
}) {
  final usage = response.usageMetadata;
  if (usage == null) {
    apiLog.info(
      '[Tier-Usage] tier=$tier locale=$locale model=$model usage=missing'
      '${note != null ? ' note=$note' : ''}',
    );
    return;
  }
  final input = usage.promptTokenCount ?? 0;
  final output = usage.candidatesTokenCount ?? 0;
  final total = usage.totalTokenCount ?? 0;
  apiLog.info(
    '[Tier-Usage] tier=$tier locale=$locale model=$model '
    'input=$input output=$output total=$total'
    '${note != null ? ' note=$note' : ''}',
  );
}
