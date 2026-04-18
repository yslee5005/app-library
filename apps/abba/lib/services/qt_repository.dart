import '../models/qt_passage.dart';

/// Abstract QT passages repository
abstract class QtRepository {
  /// Get today's QT passages (10 passages, current batch, user's locale)
  Future<List<QTPassage>> getTodayPassages({required String locale});
}
