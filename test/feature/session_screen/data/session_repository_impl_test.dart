import 'package:flutter_test/flutter_test.dart';
import 'package:list_project/feature/session_screen/data/session_repository_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:list_project/core/sourse/model/session_source_model.dart';
import 'package:list_project/core/sourse/session_source.dart';

@GenerateMocks([SessionSource])
import 'session_repository_impl_test.mocks.dart';

void main() {
  group('SessionRepositoryImpl', () {
    late MockSessionSource mockSource;
    late SessionRepositoryImpl repository;

    setUp(() {
      mockSource = MockSessionSource();
      repository = SessionRepositoryImpl(sessionSource: mockSource);
    });

    test('fetch delegates to SessionSource', () async {
      final testData = [
        SessionSourceModel(DateTime(2025, 7, 1), 'Test Customer', 100),
      ];

      when(mockSource.fetch()).thenAnswer((_) async => testData);

      final result = await repository.fetch();

      verify(mockSource.fetch()).called(1);
      expect(result, testData);
    });

    test('fetch handles errors', () async {
      when(mockSource.fetch()).thenThrow(Exception('Test error'));

      expect(() => repository.fetch(), throwsA(isA<Exception>()));
    });
  });
}