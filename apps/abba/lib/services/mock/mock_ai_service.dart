import '../../models/prayer.dart';
import '../ai_service.dart';
import '../mock_data.dart';

class MockAiService implements AiService {
  final MockDataService _mockData;

  MockAiService(this._mockData);

  @override
  Future<PrayerResult> analyzePrayer({
    required String transcript,
    required String locale,
  }) async {
    // Simulate AI processing time
    await Future<void>.delayed(const Duration(seconds: 2));
    return _mockData.getPrayerResult();
  }
}
