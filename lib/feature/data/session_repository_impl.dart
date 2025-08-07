import 'package:list_project/core/sourse/model/session_source_model.dart';
import 'package:list_project/core/sourse/session_source.dart';
import 'package:list_project/feature/data/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionSource _sessionSource;

  SessionRepositoryImpl({required SessionSource sessionSource }) : _sessionSource = sessionSource;

  @override
  Future<List<SessionSourceModel>> fetch() async {
    return _sessionSource.fetch();
  }

  @override
  Future<List<SessionSourceModel>> fetchNextPage() {
   return _sessionSource.fetchNextPage();
  }

}