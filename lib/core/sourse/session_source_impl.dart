import 'package:list_project/core/sourse/model/session_source_model.dart';
import 'package:list_project/core/sourse/session_source.dart';

class SessionSourceImpl implements SessionSource {
  @override
  Future<List<SessionSourceModel>> fetch() {
    return Future.value([
      SessionSourceModel(DateTime(2025, 7, 1), 'Customer A', 100),
      SessionSourceModel(DateTime(2025, 7, 1), 'Customer B', 200),
      SessionSourceModel(DateTime(2025, 7, 1), 'Customer C', 300),
      SessionSourceModel(DateTime(2025, 7, 2), 'Customer D', 300),
      SessionSourceModel(DateTime(2025, 7, 2), 'Customer E', 300),
      SessionSourceModel(DateTime(2025, 7, 2), 'Customer F', 300),
      SessionSourceModel(DateTime(2025, 7, 2), 'Customer A', 300),
      SessionSourceModel(DateTime(2025, 7, 3), 'Customer B', 300),
    ]);
  }
}