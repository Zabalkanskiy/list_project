import 'package:list_project/feature/presentation/bloc/day_sessions.dart';

abstract interface class SessionUseCase {
  Future<List<DaySessions>> fetch();
}