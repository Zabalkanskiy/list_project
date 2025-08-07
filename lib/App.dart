import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:list_project/feature/session_screen/presentation/bloc/session_bloc.dart';
import 'package:list_project/feature/session_screen/presentation/ui/session_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
   return BlocProvider(
      create: (context) => GetIt.I<SessionBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SessionScreen(),
      ),
    );
  }

}