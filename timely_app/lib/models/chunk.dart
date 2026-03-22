enum ChunkType { daily, periodic }

class Chunk {
  final String name;
  final ChunkType type;
  final int? chunkId;
  // TODO: deprecate isActive
  final bool isActive;
  final int startHour;
  final int endHour;
  Chunk({
    required this.name,
    required this.type,
    this.chunkId,
    required this.endHour,
    required this.startHour,
    required this.isActive,
  });
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
