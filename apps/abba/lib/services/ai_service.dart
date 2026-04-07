import '../models/prayer.dart';
import '../models/qt_meditation_result.dart';

/// Abstract AI service — mock returns JSON file data, real calls OpenAI API
abstract class AiService {
  /// Analyze prayer transcript and return structured result
  Future<PrayerResult> analyzePrayer({
    required String transcript,
    required String locale,
  });

  /// Analyze QT meditation and return structured result
  Future<QtMeditationResult> analyzeMeditation({
    required String passageReference,
    required String passageText,
    required String meditationText,
    required String locale,
  });
}
