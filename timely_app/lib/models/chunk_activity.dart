/// Defines how an activity behaves over time.
enum ActivityType { everyday, periodic, range }

/// Base sealed class for all chunk activities.
sealed class ChunkActivity {
  final int? id;
  final String name;
  final ActivityType type;
  final String description;

  final bool completed;

  ChunkActivity({
    this.id,
    required this.name,
    required this.type,
    required this.description,
    this.completed = false,
  });
}

/// A everyday activity (e.g. daily habit).
final class EverydayActivity extends ChunkActivity {
  final DateTime? date;

  EverydayActivity({
    this.date,
    required super.name,
    super.completed = false,
    required super.description,
  }) : super(type: ActivityType.everyday);
}

/// A periodic activity that happens on a single day.
final class PeriodicActivity extends ChunkActivity {
  final List<String> weekday;

  PeriodicActivity({
    required this.weekday,
    required super.name,
    super.completed = false,
    required super.description,
  }) : super(type: ActivityType.periodic);
}

/// A range-based activity that spans multiple days.
final class RangeActivity extends ChunkActivity {
  final DateTime startDate;
  final DateTime endDate;

  RangeActivity({
    required super.name,
    required this.endDate,
    required this.startDate,
    super.completed = false,
    required super.description,
  }) : assert(
         !endDate.isBefore(startDate),
         'endDate must be on or after startDate',
       ),
       super(type: ActivityType.range);
}
