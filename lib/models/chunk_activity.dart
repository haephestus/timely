// chunk_activity.dart

enum Frequency { onceoff, daily, weekly, seasonal }

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

final class OnceOffActivity extends ChunkActivity {
  final DateTime? date;
  OnceOffActivity({
    super.id,
    super.chunkId,
    this.date,
    super.completed = false,
    required super.description,
    super.startTime,
    super.endTime,
  }) : super(frequency: Frequency.daily);
}

final class DailyActivity extends ChunkActivity {
  final DateTime? date;

  DailyActivity({
    super.id,
    super.chunkId,
    this.date,
    super.completed = false,
    required super.description,
    super.startTime,
    super.endTime,
  }) : super(frequency: Frequency.daily);
}

final class WeeklyActivity extends ChunkActivity {
  final List<String> weekday;

  WeeklyActivity({
    super.id,
    super.chunkId,
    required this.weekday,
    super.completed = false,
    required super.description,
    super.startTime,
    super.endTime,
  }) : super(frequency: Frequency.weekly);
}

final class SeasonalActivity extends ChunkActivity {
  final DateTime startDate;
  final DateTime endDate;

  SeasonalActivity({
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
