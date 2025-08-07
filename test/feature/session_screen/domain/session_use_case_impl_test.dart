import 'package:flutter_test/flutter_test.dart';
import 'package:list_project/core/sourse/model/session_source_model.dart';
import 'package:list_project/feature/session_screen/data/session_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:list_project/feature/session_screen/domain/session_use_case_impl.dart';

@GenerateMocks([SessionRepository])
import 'session_use_case_impl_test.mocks.dart';

void main() {
  group('SessionUseCaseImpl', () {
    late MockSessionRepository mockRepository;
    late SessionUseCaseImpl useCase;

    setUp(() {
      mockRepository = MockSessionRepository();
      useCase = SessionUseCaseImpl(sessionRepository: mockRepository);
    });

    test('fetch groups and sorts sessions correctly', () async {
      final testData = [
        SessionSourceModel(DateTime(2025, 7, 1), 'A', 100),
        SessionSourceModel(DateTime(2025, 7, 1), 'B', 200),
        SessionSourceModel(DateTime(2025, 7, 2), 'C', 300),
      ];

      when(mockRepository.fetch()).thenAnswer((_) async => testData);

      final result = await useCase.fetch();

      // Проверка количества дней
      expect(result.length, 2);

      // Проверка первого дня
      expect(result[0].date, DateTime(2025, 7, 1));
      expect(result[0].sessions.length, 2);
      expect(result[0].total, 300);

      // Проверка второго дня
      expect(result[1].date, DateTime(2025, 7, 2));
      expect(result[1].sessions.length, 1);
      expect(result[1].total, 300);

      // Проверка сортировки (от старых к новым)
      expect(result[0].date.isBefore(result[1].date), true);
    });

    test('fetch handles empty list', () async {
      when(mockRepository.fetch()).thenAnswer((_) async => []);

      final result = await useCase.fetch();

      expect(result, isEmpty);
    });
  });
}