/// Defines how an activity behaves over time.
enum ActivityType { repeatable, oneOff, range }

/// Base sealed class for all chunk activities.
sealed class ChunkActivity {
  final String name;
  final ActivityType type;
  final String description;

  final bool completed;

  ChunkActivity({
    required this.name,
    required this.type,
    required this.description,
    this.completed = false,
  });
}

/// A repeatable activity (e.g. daily habit).
/// Uses a single date representing the specific day instance.
final class RepeatableActivity extends ChunkActivity {
  final DateTime date;

  RepeatableActivity({
    required this.date,
    required super.name,
    super.completed = false,
    required super.description,
  }) : super(type: ActivityType.repeatable);
}

/// A one-off activity that happens on a single day.
final class OneOffActivity extends ChunkActivity {
  final DateTime date;

  OneOffActivity({
    required this.date,
    required super.name,
    super.completed = false,
    required super.description,
  }) : super(type: ActivityType.repeatable);
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
