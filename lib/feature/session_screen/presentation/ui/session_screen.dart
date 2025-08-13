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
  static final DateFormat _dateFormat = DateFormat('EEEE, MMMM d, y');

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
            return const Center(child: CircularProgressIndicator());
          }
          ///общий список дней с записями
          final List<DaySessions> days = state.listDaySessions;

          // Precompute day section lengths and offsets for O(log n) index -> day mapping
          ///список соостоящий из колличества записей в дне + 2 хэдер и футер
          final List<int> daySectionLengths = List<int>.generate(
            days.length,
            (int i) => days[i].sessions.length + 2, // header + sessions + total
            growable: false,
          );
          ///используется для подсчета отступов пишет общую сумму runningTotal в конкретном дне
          ///что бы найти конкретные данные используется
          final List<int> dayOffsets = <int>[];
          ///общее колличество элементов в списке
          ///элементы (хэдер колличество записей в дне и футор) в одном элементе содержатся
          ///для построения списка используется
          int runningTotal = 0;
          for (final length in daySectionLengths) {
            dayOffsets.add(runningTotal);
            runningTotal += length;
          }

          return CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate((
                  BuildContext context,
                  int index,
                ) {
                  final int dayIndex = _findDayIndex(dayOffsets, index);
                  final DaySessions day = days[dayIndex];
                  ///первый индекс списка хэдер если 0
                  final int localIndex = index - dayOffsets[dayIndex];
                  /// общая длина локального списка
                  final int sessionsCount = day.sessions.length;

                  if (localIndex == 0) {
                    return _DayHeader(
                      formattedDate: _dateFormat.format(day.date),
                    );
                  }
                  ///футер ели больше элементов списка +2(хэдер + футер)
                  if (localIndex == sessionsCount + 1) {
                    return _DayTotal(total: day.total);
                  }

                  // session row
                  ///непонял
                  final session = day.sessions[localIndex - 1];
                  final bool isFirst = localIndex == 1;
                  final bool isLast = localIndex == sessionsCount;
                  return _SessionRow(
                    customer: session.customer,
                    amount: session.amount,
                    isFirst: isFirst,
                    isLast: isLast,
                  );
                }, childCount: runningTotal),
              ),
            ],
          );
        },
      ),
    );
  }
}

int _findDayIndex(List<int> dayOffsets, int globalIndex) {
  // Binary search for the greatest offset <= globalIndex
  int low = 0;
  int high = dayOffsets.length - 1;
  while (low <= high) {
    final int mid = low + ((high - low) >> 1);
    if (dayOffsets[mid] == globalIndex) {
      return mid;
    } else if (dayOffsets[mid] < globalIndex) {
      low = mid + 1;
    } else {
      high = mid - 1;
    }
  }
  return high.clamp(0, dayOffsets.length - 1);
}

class _DayHeader extends StatelessWidget {
  final String formattedDate;
  const _DayHeader({required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
      padding: const EdgeInsets.all(12.0),
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            'Date:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Text(
            formattedDate,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  final String customer;
  final num amount;
  final bool isFirst;
  final bool isLast;

  const _SessionRow({
    required this.customer,
    required this.amount,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: _getBorderRadius(isFirst, isLast),
        border: !isLast
            ? const Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
            : null,
      ),
      child: ListTile(
        title: Text(customer),
        trailing: Text(
          amount.toStringAsFixed(0),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  BorderRadius _getBorderRadius(bool isFirst, bool isLast) {
    if (isFirst && isLast) return BorderRadius.circular(12);
    if (isFirst) return const BorderRadius.vertical(top: Radius.circular(12));
    if (isLast) return const BorderRadius.vertical(bottom: Radius.circular(12));
    return BorderRadius.zero;
  }
}

class _DayTotal extends StatelessWidget {
  final double total;
  const _DayTotal({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 16, bottom: 8),
      padding: const EdgeInsets.all(12.0),
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Total:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(total.toStringAsFixed(0)), // Добавить отображение
        ],
      ),
    );
  }
}
