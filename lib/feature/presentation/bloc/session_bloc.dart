import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_project/core/sourse/model/session_source_model.dart';
import 'package:list_project/feature/data/session_repository.dart';
import 'package:list_project/feature/domain/session_use_case.dart';
import 'package:list_project/feature/presentation/bloc/day_sessions.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionUseCase _sessionUseCase;

  SessionBloc({required SessionUseCase  sessionUseCase}) :
        _sessionUseCase = sessionUseCase, super(SessionState(listDaySessions: [],isLoading: true )) {
    on<SessionLoadingEvent>(onSessionLoadingEvent);
  }

  Future<void> onSessionLoadingEvent(
      SessionLoadingEvent event,
      Emitter<SessionState> emit,
      ) async {
    try {
      List<DaySessions> list = await _sessionUseCase.fetch();
      emit(state.copyWith(listDaySessions: list, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

}

abstract class SessionEvent {}

class SessionLoadingEvent extends SessionEvent {}

class SessionState extends Equatable {
 final List<DaySessions> listDaySessions;
 final bool isLoading;
 final String? error;

  SessionState({required this.listDaySessions, required this.isLoading, this.error});

  SessionState copyWith({
    List<DaySessions>? listDaySessions,
    bool? isLoading,
    String? error,
  }) {
    return SessionState(
      listDaySessions: listDaySessions ?? this.listDaySessions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [listDaySessions, isLoading, error];
}