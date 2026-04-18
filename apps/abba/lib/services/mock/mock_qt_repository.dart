import '../../models/qt_passage.dart';
import '../mock_data.dart';
import '../qt_repository.dart';

class MockQtRepository implements QtRepository {
  final MockDataService _mockData;

  MockQtRepository(this._mockData);

  @override
  Future<List<QTPassage>> getTodayPassages({required String locale}) async {
    return _mockData.getQTPassages();
  }
}
