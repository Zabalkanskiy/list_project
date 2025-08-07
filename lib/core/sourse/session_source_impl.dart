import 'dart:math';

import 'package:list_project/core/sourse/model/session_source_model.dart';
import 'package:list_project/core/sourse/session_source.dart';

class SessionSourceImpl implements SessionSource {
  final Random _random = Random();
  static const int maxClients = 1000;
  static const int maxDays = 365;

  // Кэш для хранения сгенерированных данных
  List<SessionSourceModel>? _cachedSessions;

  @override
  Future<List<SessionSourceModel>> fetch() async {
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

  // Метод для очистки кэша (если нужно)
  void clearCache() {
    _cachedSessions = null;
  }
}