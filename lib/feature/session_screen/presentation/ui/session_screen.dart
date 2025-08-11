import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:list_project/feature/session_screen/presentation/bloc/day_sessions.dart';
import 'package:list_project/feature/session_screen/presentation/bloc/session_bloc.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<SessionBloc>().add(SessionLoadMoreEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: BlocConsumer<SessionBloc, SessionState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.listDaySessions.length,
            itemBuilder: (context, index) {
              // if (index >= state.listDaySessions.length) {
              //   return Center(child: CircularProgressIndicator());
              // }
              final day = state.listDaySessions[index];
              return _buildDayCard(day);
            },
          );
        },
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
              ),
              Text(
                DateFormat('EEEE, MMMM d, y').format(day.date), // Форматируем дату
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),


        SizedBox(
          // Фиксируем высоту
          height: day.sessions.length * 56.0, // Вычисленная высота
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: day.sessions.length,
            itemBuilder: (context, index) {
              final session = day.sessions[index];
              final isFirst = index == 0;
              final isLast = index == day.sessions.length - 1;

              return Container(
                height: 56.0, // Фиксированная высота элемента
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: _getBorderRadius(isFirst, isLast),
                  border: !isLast ? const Border(bottom: BorderSide(width: 1.0, color: Colors.grey)) : null,
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
              ),
              Text(
                day.total.toStringAsFixed(2),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

BorderRadius _getBorderRadius(bool isFirst, bool isLast) {
  if (isFirst && isLast) return BorderRadius.circular(12);
  if (isFirst) return const BorderRadius.vertical(top: Radius.circular(12));
  if (isLast) return const BorderRadius.vertical(bottom: Radius.circular(12));
  return BorderRadius.zero;
}
