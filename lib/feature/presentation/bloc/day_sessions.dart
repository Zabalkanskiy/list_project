import 'package:equatable/equatable.dart';
import 'package:list_project/core/sourse/model/session_source_model.dart';

class DaySessions extends Equatable {
  final DateTime date;
  final List<SessionSourceModel> sessions;
  final double total;

  DaySessions({
    required this.date,
    required this.sessions,
    required this.total,
  });

  @override

  List<Object?> get props => [date, sessions, total];
}