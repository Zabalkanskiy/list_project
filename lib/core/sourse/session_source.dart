import 'package:list_project/core/sourse/model/session_source_model.dart';

abstract interface class SessionSource {
  Future<List<SessionSourceModel>> fetch();
}