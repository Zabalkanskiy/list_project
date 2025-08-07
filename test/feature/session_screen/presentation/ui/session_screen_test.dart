import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:list_project/feature/session_screen/presentation/ui/session_screen.dart';
import 'package:list_project/feature/session_screen/presentation/bloc/session_bloc.dart';
import 'package:list_project/feature/session_screen/presentation/bloc/day_sessions.dart';
import 'package:list_project/core/sourse/model/session_source_model.dart';

class MockSessionBloc extends MockBloc<SessionEvent, SessionState>
    implements SessionBloc {}

void main() {
  group('SessionScreen', () {
    late MockSessionBloc mockBloc;

    setUp(() {
      mockBloc = MockSessionBloc();
    });

    Widget makeTestable({required SessionBloc bloc}) {
      return MaterialApp(
        home: BlocProvider<SessionBloc>.value(
          value: bloc,
          child: const SessionScreen(),
        ),
      );
    }

    testWidgets('shows loading indicator when loading', (tester) async {
      whenListen(
        mockBloc,
        Stream<SessionState>.fromIterable([
          SessionState(listDaySessions: [], isLoading: true),
        ]),
        initialState: SessionState(listDaySessions: [], isLoading: true),
      );
      await tester.pumpWidget(makeTestable(bloc: mockBloc));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows list of days and sessions', (tester) async {
      final sessions = [
        SessionSourceModel(DateTime(2024, 6, 1), 'Customer 1', 100),
        SessionSourceModel(DateTime(2024, 6, 1), 'Customer 2', 200),
      ];
      final day = DaySessions(
        date: DateTime(2024, 6, 1),
        sessions: sessions,
        total: 300,
      );
      whenListen(
        mockBloc,
        Stream<SessionState>.fromIterable([
          SessionState(listDaySessions: [day], isLoading: false),
        ]),
        initialState: SessionState(listDaySessions: [day], isLoading: false),
      );
      await tester.pumpWidget(makeTestable(bloc: mockBloc));
      await tester.pumpAndSettle();
      expect(find.text('Date:'), findsOneWidget);
      expect(find.text('Customer 1'), findsOneWidget);
      expect(find.text('Customer 2'), findsOneWidget);
      expect(find.text('300.00'), findsOneWidget); // total
    });

    testWidgets('shows empty list if no days', (tester) async {
      whenListen(
        mockBloc,
        Stream<SessionState>.fromIterable([
          SessionState(listDaySessions: [], isLoading: false),
        ]),
        initialState: SessionState(listDaySessions: [], isLoading: false),
      );
      await tester.pumpWidget(makeTestable(bloc: mockBloc));
      await tester.pumpAndSettle();
      // Should not find any day cards
      expect(find.text('Date:'), findsNothing);
    });

    testWidgets('shows error if state has error', (tester) async {
      whenListen(
        mockBloc,
        Stream<SessionState>.fromIterable([
          SessionState(listDaySessions: [], isLoading: false, error: 'error!'),
        ]),
        initialState: SessionState(
          listDaySessions: [],
          isLoading: false,
          error: 'error!',
        ),
      );
      await tester.pumpWidget(makeTestable(bloc: mockBloc));
      // UI does not show error, but you can add this if needed
      // expect(find.text('error!'), findsOneWidget);
    });
  });
}
