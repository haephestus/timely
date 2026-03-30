// chunk_activity.dart

enum ActivityType { everyday, periodic, range }

sealed class ChunkActivity {
  final int? id;
  final ActivityType type;
  final String description;
  final bool completed;
  final String? startTime; // 'HH:MM'
  final String? endTime; // 'HH:MM'

  ChunkActivity({
    this.id,
    required this.type,
    required this.description,
    this.completed = false,
    this.startTime,
    this.endTime,
  });
}

final class EverydayActivity extends ChunkActivity {
  final DateTime? date;

  EverydayActivity({
    super.id,
    this.date,
    super.completed = false,
    required super.description,
    super.startTime,
    super.endTime,
  }) : super(type: ActivityType.everyday);
}

final class PeriodicActivity extends ChunkActivity {
  final List<String> weekday;

  PeriodicActivity({
    super.id,
    required this.weekday,
    super.completed = false,
    required super.description,
    super.startTime,
    super.endTime,
  }) : super(type: ActivityType.periodic);
}

final class RangeActivity extends ChunkActivity {
  final DateTime startDate;
  final DateTime endDate;

  RangeActivity({
    super.id,
    required this.endDate,
    required this.startDate,
    super.completed = false,
    required super.description,
    super.startTime,
    super.endTime,
  }) : assert(
         !endDate.isBefore(startDate),
         'endDate must be on or after startDate',
       ),
       super(type: ActivityType.range);
}
