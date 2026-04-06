import '../models/prayer.dart';

/// Abstract AI service — mock returns JSON file data, real calls OpenAI API
abstract class AiService {
  /// Analyze prayer transcript and return structured result
  Future<PrayerResult> analyzePrayer({
    required String transcript,
    required String locale,
  });
}
