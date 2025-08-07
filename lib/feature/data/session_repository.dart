import 'package:list_project/core/sourse/model/session_source_model.dart';

abstract interface class SessionRepository {
  Future<List<SessionSourceModel>> fetch();

  Future<List<SessionSourceModel>> fetchNextPage();
}