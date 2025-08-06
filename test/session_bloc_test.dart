import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:list_project/feature/presentation/bloc/session_bloc.dart';
import 'package:list_project/feature/domain/session_use_case.dart';
import 'package:list_project/feature/presentation/bloc/day_sessions.dart';

@GenerateMocks([SessionUseCase])
import 'session_bloc_test.mocks.dart';

void main() {
  group('SessionBloc', () {
    late MockSessionUseCase mockUseCase;
    late SessionBloc bloc;

    setUp(() {
      mockUseCase = MockSessionUseCase();
      bloc = SessionBloc(sessionUseCase: mockUseCase);
    });

    blocTest<SessionBloc, SessionState>(
      'emits [loading, loaded] when fetch succeeds',
      build: () {
        when(mockUseCase.fetch()).thenAnswer((_) async => [
          DaySessions(
            date: DateTime(2025, 7, 1),
            sessions: [],
            total: 0,
          )
        ]);
        return bloc;
      },
      act: (bloc) => bloc.add(SessionLoadingEvent()),
      expect: () => [
        // SessionState(listDaySessions: [], isLoading: true),
        SessionState(
          listDaySessions: [
            DaySessions(
              date: DateTime(2025, 7, 1),
              sessions: [],
              total: 0,
            )
          ],
          isLoading: false,
        ),
      ],
    );

    blocTest<SessionBloc, SessionState>(
      'emits [loading, error] when fetch fails',
      build: () {
        when(mockUseCase.fetch()).thenThrow(Exception('Test error'));
        return bloc;
      },
      act: (bloc) => bloc.add(SessionLoadingEvent()),
      expect: () => [
        // SessionState(listDaySessions: [], isLoading: true),
        SessionState(
          listDaySessions: [],
          isLoading: true,
          error: 'Exception: Test error',
        ),
      ],
    );
  });
}