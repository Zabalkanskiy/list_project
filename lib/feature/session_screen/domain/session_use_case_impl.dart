import 'package:collection/collection.dart';
import 'package:list_project/core/sourse/model/session_source_model.dart';
import 'package:list_project/feature/session_screen/data/session_repository.dart';
import 'package:list_project/feature/session_screen/domain/session_use_case.dart';
import 'package:list_project/feature/session_screen/presentation/bloc/day_sessions.dart';

class SessionUseCaseImpl implements SessionUseCase {
  final SessionRepository _sessionRepository;

  SessionUseCaseImpl({required SessionRepository sessionRepository}) : _sessionRepository = sessionRepository;

  @override
  Future<List<DaySessions>> fetch({bool firstPage = true}) async {

      List<SessionSourceModel> list;
      if(firstPage) {
        list = await _sessionRepository.fetch();
      } else {
        list = await _sessionRepository.fetchNextPage();
      }

      // Группируем сессии по дате
      final Map<DateTime, List<SessionSourceModel>> groups = groupBy(list, (session) => session.date);

      // Создаем структуру данных по дням с подсчетом итогов
      final List<DaySessions> dayGroups = groups.entries.map((entry) {
        final date = entry.key;
        final sessions = entry.value;
        final total = sessions.fold(0.0, (sum, session) => sum + session.amount);

        return DaySessions(date: date, sessions: sessions, total: total);
      }).toList();

      // Сортируем по дате (от новых к старым)
      dayGroups.sort((a, b) => a.date.compareTo(a.date));

      return dayGroups;
  }

  ///бизнес логика приложения здесь описывается
  // @override
  // Future<List<DaySessions>> fetch() async {
  //   List<SessionSourceModel> list = await _sessionRepository.fetch();
  //
  //   // Группируем сессии по дате
  //   final Map<DateTime, List<SessionSourceModel>> groups = groupBy(list, (session) => session.date);
  //
  //   // Создаем структуру данных по дням с подсчетом итогов
  //   final List<DaySessions> dayGroups = groups.entries.map((entry) {
  //     final date = entry.key;
  //     final sessions = entry.value;
  //     final total = sessions.fold(0.0, (sum, session) => sum + session.amount);
  //
  //     return DaySessions(date: date, sessions: sessions, total: total);
  //   }).toList();
  //
  //   // Сортируем по дате (от новых к старым)
  //   dayGroups.sort((a, b) => a.date.compareTo(a.date));
  //
  //   return dayGroups;
  // }
}
