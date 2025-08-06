import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:list_project/feature/presentation/bloc/day_sessions.dart';
import 'package:list_project/feature/presentation/bloc/session_bloc.dart';

class  SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.grey[300] ,
     body: BlocConsumer<SessionBloc, SessionState>(
       listener: (context, state) {},
       builder: (context, state) {
         if (state.isLoading) {
           return Center(child: CircularProgressIndicator());
         }
         return ListView.builder(
           itemCount: state.listDaySessions.length,
           itemBuilder: (context, index) {
             final day = state.listDaySessions[index];
             return _buildDayCard(day);
           },
         );
       }
     ),
   );
  }
}

Widget _buildDayCard(DaySessions day) {
  return Container(
    margin: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Заголовок с датой
        Container(
          padding: const EdgeInsets.all(12.0),
          color: Colors.grey[300],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black),
              ),
              Text(
                DateFormat('EEEE, MMMM d, y').format(day.date), // Форматируем дату
                style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),

            ],
          ),
        ),

        // Список сессий за день
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: day.sessions.length,
          separatorBuilder: (context, index) => const Divider(height: 1),

          itemBuilder: (context, index) {
            final session = day.sessions[index];
            final isFirst = index == 0;
            final isLast = index == day.sessions.length - 1;
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                borderRadius: isFirst && isLast
                    ? BorderRadius.circular(12) // Если только один элемент
                    : isFirst
                    ? const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                )
                    : isLast
                    ? const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                )
                    : BorderRadius.zero,
                ),
              child: ListTile(

                title: Text(session.customer),
                trailing: Text(
                  session.amount.toStringAsFixed(2),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),

        // Итог за день
        Container(
          padding: const EdgeInsets.all(12.0),
          color: Colors.grey[300],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Text(
                day.total.toStringAsFixed(2),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
