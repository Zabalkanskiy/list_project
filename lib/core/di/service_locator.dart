import 'package:get_it/get_it.dart';
import 'package:list_project/core/sourse/session_source.dart';
import 'package:list_project/core/sourse/session_source_impl.dart';
import 'package:list_project/feature/session_screen/data/session_repository.dart';
import 'package:list_project/feature/session_screen/data/session_repository_impl.dart';
import 'package:list_project/feature/session_screen/domain/session_use_case.dart';
import 'package:list_project/feature/session_screen/domain/session_use_case_impl.dart';
import 'package:list_project/feature/session_screen/presentation/bloc/session_bloc.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Регистрируем зависимости
  getIt.registerSingleton<SessionSource>(SessionSourceImpl());

  getIt.registerSingleton<SessionRepository>(
    SessionRepositoryImpl(sessionSource: getIt<SessionSource>()),
  );

  getIt.registerSingleton<SessionUseCase>(
    SessionUseCaseImpl(sessionRepository: getIt<SessionRepository>()),
  );

  // Блок регистрируем как фабрику (будет создаваться новый при каждом запросе)
  getIt.registerFactory<SessionBloc>(
        () => SessionBloc(sessionUseCase: getIt<SessionUseCase>())..add(SessionLoadingEvent()),
  );
}