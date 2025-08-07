import 'dart:math';

import 'package:list_project/core/sourse/model/session_source_model.dart';
import 'package:list_project/core/sourse/session_source.dart';

class SessionSourceImpl implements SessionSource {
  final Random _random = Random();
  static const int maxClients = 1000;
  static const int maxDays = 365;
  static const int targetPageSize = 30; // Примерное количество записей на странице

  // Кэш для хранения сгенерированных данных
  List<SessionSourceModel>? _cachedSessions;

  int _currentPosition = 0;

  @override
  Future<List<SessionSourceModel>> fetch() async {

    return _fetchPage(reset: true);
  }

  @override
  Future<List<SessionSourceModel>> fetchNextPage() async {

    return _fetchPage(reset: false);
  }


  Future<List<SessionSourceModel>> _fetchPage({required bool reset}) async {
    // ИЗМЕНЕНО: Полностью переработал логику пагинации

    if (reset) {
      _currentPosition = 0; // Сброс позиции при первой загрузке
    }

    // Генерация данных при первом запросе
    if (_cachedSessions == null) {
      await _generateAllSessions();
      // ИЗМЕНЕНО: Добавил сортировку по дате
      _cachedSessions!.sort((a, b) => a.date.compareTo(b.date));
    }

    if (_currentPosition >= _cachedSessions!.length) {
      return []; // Нет данных для возврата
    }



    // 1. Получаем оставшиеся сессии
    final remainingSessions = _cachedSessions!.sublist(_currentPosition);

    // 2. Извлекаем уникальные даты
    final uniqueDates = remainingSessions.map((s) => _dateOnly(s.date)).toSet();

    // 3. Выбираем дни для текущей страницы
    final List<DateTime> daysForPage = [];
    int sessionsCount = 0;

    for (final date in uniqueDates) {
      final daySessions = remainingSessions.where((s) => _dateOnly(s.date) == date);
      final dayCount = daySessions.length;

      //  Добавляем день целиком, даже если он не влезает в targetPageSize
      // Но гарантируем что на каждой странице будет хотя бы один день
      if (sessionsCount + dayCount <= targetPageSize || daysForPage.isEmpty) {
        daysForPage.add(date);
        sessionsCount += dayCount;
      } else {
        break; // Прекращаем если достигли предела
      }
    }

    // 4. Фильтруем сессии по выбранным дням
    final result = remainingSessions
        .where((s) => daysForPage.contains(_dateOnly(s.date)))
        .toList();

    // 5. Обновляем позицию для следующей страницы
    _currentPosition += result.length;

    return result;
  }

  // НОВЫЙ МЕТОД: Приводит дату к формату без времени
  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Future<List<SessionSourceModel>> _generateAllSessions() async {
    // Если данные уже есть в кэше, возвращаем их
    if (_cachedSessions != null) {
      return _cachedSessions!;
    }

    // Генерация новых данных
    final List<SessionSourceModel> sessions = [];
    final DateTime now = DateTime.now();
    final DateTime startDate = DateTime(now.year, 1, 1);

    // Генерируем список уникальных клиентов
    final List<String> allCustomers = List.generate(
        maxClients,
            (i) => 'Customer ${i + 1}'
    );

    for (int day = 0; day < maxDays; day++) {
      final DateTime date = startDate.add(Duration(days: day));

      // Количество клиентов в этот день (1-1000)
      final int clientsToday = _random.nextInt(5) + 1;

      // Перемешиваем клиентов для случайного выбора
      allCustomers.shuffle(_random);

      for (int i = 0; i < clientsToday; i++) {
        final double amount = _random.nextDouble() * 1000;
        sessions.add(SessionSourceModel(date, allCustomers[i], amount.toInt()));
      }
    }

    // Сохраняем данные в кэш
    _cachedSessions = sessions;

    return sessions;
  }

  @override
  void clearCache() {
    _cachedSessions = null;
    _currentPosition = 0; // ИЗМЕНЕНО: Сбрасываем позицию
  }
}