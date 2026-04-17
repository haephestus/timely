// chunk_activity.dart

enum Frequency { everyday, weekly, seasonal }

sealed class ChunkActivity {
  final int? id;
  final int? chunkId;
  final Frequency frequency;
  final String description;
  final bool completed;
  final String? startTime; // 'HH:MM'
  final String? endTime; // 'HH:MM'

  ChunkActivity({
    required this.id,
    required this.chunkId,
    required this.frequency,
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
    super.chunkId,
    this.date,
    super.completed = false,
    required super.description,
    super.startTime,
    super.endTime,
  }) : super(frequency: Frequency.everyday);
}

final class PeriodicActivity extends ChunkActivity {
  final List<String> weekday;

  PeriodicActivity({
    super.id,
    super.chunkId,
    required this.weekday,
    super.completed = false,
    required super.description,
    super.startTime,
    super.endTime,
  }) : super(frequency: Frequency.weekly);
}

final class RangeActivity extends ChunkActivity {
  final DateTime startDate;
  final DateTime endDate;

  RangeActivity({
    super.id,
    super.chunkId,
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
       super(frequency: Frequency.seasonal);
}
