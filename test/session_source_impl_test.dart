import 'package:flutter_test/flutter_test.dart';
import 'package:list_project/core/sourse/model/session_source_model.dart';
import 'package:list_project/core/sourse/session_source_impl.dart';

void main() {
  group('SessionSourceImpl', () {
    test('fetch returns valid data', () async {
      final source = SessionSourceImpl();
      final result = await source.fetch();

      expect(result, isA<List<SessionSourceModel>>());
      expect(result.length, 8);

      // Проверка первого элемента
      expect(result[0].date, DateTime(2025, 7, 1));
      expect(result[0].customer, 'Customer A');
      expect(result[0].amount, 100);

      // Проверка последнего элемента
      expect(result[7].date, DateTime(2025, 7, 3));
      expect(result[7].customer, 'Customer B');
      expect(result[7].amount, 300);
    });
  });
}