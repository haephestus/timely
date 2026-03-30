enum ChunkType { daily, periodic }

class Chunk {
  final int? chunkId;
  final String name;
  final ChunkType type;
  final int startHour;
  final int startMinute; // new
  final int endHour;
  final int endMinute; // new
  final bool isActive;

  const Chunk({
    this.chunkId,
    required this.name,
    required this.type,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.isActive,
  });

  // Convenience: total minutes since midnight
  int get startTotalMinutes => startHour * 60 + startMinute;
  int get endTotalMinutes => endHour * 60 + endMinute;

  // Formatted strings
  String get startTimeStr =>
      '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}';
  String get endTimeStr =>
      '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';
}

/*
final class PeriodicChunk extends Chunk {
  final int startHour;
  final int endHour;

  PeriodicChunk({
    required super.name,
    required super.chunkId,
    required super.isActive,
    required this.startHour,
    required this.endHour,
  }) : super(type: ChunkType.fixed);
}

class DailyChunk extends Chunk {
  final int startHour;
  final int duration;

  DailyChunk({
    required super.name,
    required super.chunkId,
    required super.isActive,
    required this.duration,
    required this.startHour,
  }) : assert(startHour >= 0 && startHour < 24, 'start hour must not be 0'),
       super(type: ChunkType.flexible);
}
*/
