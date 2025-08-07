import 'package:list_project/feature/session_screen/presentation/bloc/day_sessions.dart';

abstract interface class SessionUseCase {
  Future<List<DaySessions>> fetch({bool firstPage = true});



}