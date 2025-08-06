import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:list_project/core/sourse/session_source_impl.dart';
import 'package:list_project/feature/data/session_repository_impl.dart';
import 'package:list_project/feature/domain/session_use_case_impl.dart';
import 'package:list_project/feature/presentation/bloc/session_bloc.dart';
import 'package:list_project/feature/presentation/ui/session_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
   return BlocProvider(
      // create: (context) => SessionBloc(
      //   sessionUseCase: SessionUseCaseImpl(sessionRepository: SessionRepositoryImpl(
      //     sessionSource: SessionSourceImpl(),
      //   ),)
      // )..add(SessionLoadingEvent()),
      create: (context) => GetIt.I<SessionBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SessionScreen(),
      ),
    );
  }

}