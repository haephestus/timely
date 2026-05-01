import 'package:drift/drift.dart';
import 'package:timely/models/chunk_activity.dart';
import 'package:timely/utils/database/database.dart' as db;

// TODO: Chunk addtition overwrites and deletes conflicting chunks - fix
// TODO: Chunks cannot overlap sametime slots on different days - fix
// TODO: Check if overlapping activities are completed

class ChunkActivityService {
  final db.AppDb database;

  ChunkActivityService(this.database);

  /* =========================
   * CHUNKS
   * =========================
  */

  Future<List<db.Chunk>> getAllChunks() => database.getAllChunks().get();
  Future<List<db.Chunk>> getTodaysChunks(String date) =>
      database.getTodaysChunks(date).get();
  Future<List<db.Chunk>> getActiveChunks() => database.getActiveChunks().get();
  Future<db.Chunk?> getChunkByName(String name) =>
      database.getChunkInfoByChunkName(name).getSingleOrNull();

  /// Returns a conflicting chunk if the given hours overlap any existing chunk.
  /// Pass [excludeId] when editing an existing chunk so it doesn't conflict with itself.
  Future<List<db.Activity>> getOverlappingActivities(
    int chunkId,
    String startTime,
    String endTime, {
    int? excludeId,
    String? excludedDescription,
  }) async {
    final all = await (database.select(
      database.activities,
    )..where((a) => a.chunkId.equals(chunkId))).get();

    final newStart = _timeToMinutes(startTime);
    final newEnd = _timeToMinutes(endTime);

    return all.where((a) {
      if (excludeId != null && a.id == excludeId) return false;
      if (excludedDescription != null && a.description == excludedDescription) {
        return false;
      }
      if (a.startTime == null || a.endTime == null) return false;
      final aStart = _timeToMinutes(a.startTime!);
      final aEnd = _timeToMinutes(a.endTime!);
      return newStart < aEnd && newEnd > aStart;
    }).toList();
  }

  Future<db.Chunk?> getOverlappingChunk(
    int startHour,
    int startMinute,
    int endHour,
    int endMinute, {
    int? excludeId,
    String? frequency,
    String? selectedDays,
  }) async {
    final all = await getAllChunks();
    final newStart = startHour * 60 + startMinute;
    final newEnd = endHour * 60 + endMinute;

    for (final chunk in all) {
      if (excludeId != null && chunk.id == excludeId) continue;
      if (frequency != null && chunk.frequency != frequency) continue;
      if (frequency == 'weekly' &&
          selectedDays != null &&
          chunk.selectedDays != null) {
        final newDays = selectedDays.split(',').map((d) => d.trim()).toSet();
        final existingDays = chunk.selectedDays!
            .split(',')
            .map((d) => d.trim())
            .toSet();
        if (newDays.intersection(existingDays).isEmpty) continue;
      }
      final cStart = (chunk.startHour ?? 0) * 60 + chunk.startMinute!;
      final cEnd = (chunk.endHour ?? 0) * 60 + chunk.endMinute!;
      if (newStart < cEnd && newEnd > cStart) return chunk;
    }
    return null;
  }

  Future<bool> activityFitsInChunk(
    int chunkId,
    String startTime,
    String endTime,
  ) async {
    final all = await getAllChunks();
    final chunk = all.where((c) => c.id == chunkId).firstOrNull;
    if (chunk == null) return false;

    final actStart = _timeToMinutes(startTime);
    final actEnd = _timeToMinutes(endTime);
    final chunkStart = (chunk.startHour ?? 0) * 60 + chunk.startMinute!;
    final chunkEnd = (chunk.endHour ?? 0) * 60 + chunk.endMinute!;

    return actStart >= chunkStart && actEnd <= chunkEnd;
  }
  /* =========================
   * ACTIVITIES
   * =========================
  */

  Future<List<db.Activity>> _getActivitiesFromDb(int chunkId, DateTime date) {
    final dateStr = date.toIso8601String().split('T')[0];
    return database.getActivitiesByChunkId(chunkId, dateStr).get();
  }

  Future<List<ChunkActivity>> getActivitiesForChunk(
    int chunkId,
    DateTime date,
  ) async {
    final dbActivities = await _getActivitiesFromDb(chunkId, date);
    return dbActivities.map((a) {
      switch (a.frequency) {
        case 'onceoff':
          return DailyActivity(
            id: a.id,
            description: a.description,
            date: a.date != null ? DateTime.parse(a.date!) : null,
            startTime: a.startTime,
            endTime: a.endTime,
          );
        case 'daily':
          return DailyActivity(
            id: a.id,
            description: a.description,
            date: a.date != null ? DateTime.parse(a.date!) : null,
            startTime: a.startTime,
            endTime: a.endTime,
          );
        case 'weekly':
          return WeeklyActivity(
            id: a.id,
            description: a.description,
            weekday: a.selectedDays?.split(',') ?? [],
            startTime: a.startTime,
            endTime: a.endTime,
          );
        case 'seasonal':
          return SeasonalActivity(
            id: a.id,
            description: a.description,
            startDate: DateTime.parse(a.startDate!),
            endDate: DateTime.parse(a.endDate!),
            startTime: a.startTime,
            endTime: a.endTime,
          );
        default:
          throw Exception('Unknown activity frequency: ${a.frequency}');
      }
    }).toList();
  }

  /* =========================
   * INSERT / UPDATE
   * =========================
  */

  // TODO: delete activity, batch delete activity
  Future<void> addDailyActivity({
    required int chunkId,
    required String description,
    required String startTime,
    required String endTime,
  }) async {
    await _validateActivityTimes(chunkId, startTime, endTime);
    await database.batch((b) {
      b.insert(
        database.activities,
        db.ActivitiesCompanion(
          frequency: const Value('daily'),
          description: Value(description),
          chunkId: Value(chunkId),
          startTime: Value(startTime),
          endTime: Value(endTime),
          startDate: const Value.absent(),
          date: const Value.absent(),
          endDate: const Value.absent(),
        ),
      );
    });
  }

  Future<void> updateDailyActivity({
    required int id,
    required String date,
    required int chunkId,
    required String frequency,
    required String description,
    required String startTime,
    required String endTime,
  }) async {
    final original = await (database.select(
      database.activities,
    )..where((a) => a.id.equals(id))).getSingle();

    await _validateActivityTimes(
      chunkId,
      startTime,
      endTime,
      excludeId: id,
      excludedDescription: original.description,
    );

    await database.batch((b) {
      b.update(
        database.activities,
        db.ActivitiesCompanion(
          description: Value(description),
          frequency: Value(frequency),
          startTime: Value(startTime),
          endTime: Value(endTime),
        ),
        where: (tbl) =>
            tbl.chunkId.equals(chunkId) &
            tbl.frequency.equals(frequency) &
            tbl.description.equals(original.description),
      );
    });
  }

  Future<void> addOnceOffActivity({
    required int chunkId,
    required String description,
    required String startTime,
    required String endTime,
    required String date,
  }) async {
    await _validateActivityTimes(chunkId, startTime, endTime);
    await database.batch((b) {
      b.insert(
        database.activities,
        db.ActivitiesCompanion(
          frequency: const Value('onceoff'),
          description: Value(description),
          chunkId: Value(chunkId),
          startTime: Value(startTime),
          endTime: Value(endTime),
          startDate: const Value.absent(),
          date: Value(date),
          endDate: const Value.absent(),
        ),
      );
    });
  }

  Future<void> updateOnceOffActivity({
    required int id,
    required String date,
    required int chunkId,
    required String frequency,
    required String description,
    required String startTime,
    required String endTime,
  }) async {
    final original = await (database.select(
      database.activities,
    )..where((a) => a.id.equals(id))).getSingle();

    await _validateActivityTimes(
      chunkId,
      startTime,
      endTime,
      excludeId: id,
      excludedDescription: original.description,
    );

    await database.batch((b) {
      b.update(
        database.activities,
        db.ActivitiesCompanion(
          description: Value(description),
          frequency: Value(frequency),
          startTime: Value(startTime),
          endTime: Value(endTime),
          date: Value(date),
        ),
        where: (tbl) =>
            tbl.date.equals(date) &
            tbl.chunkId.equals(chunkId) &
            tbl.frequency.equals(frequency) &
            tbl.description.equals(original.description),
      );
    });
  }

  Future<void> addWeeklyActivity({
    required String weekday,
    required int chunkId,
    required String description,
    required String startTime,
    required String endTime,
  }) async {
    await _validateActivityTimes(chunkId, startTime, endTime);
    await database
        .into(database.activities)
        .insert(
          db.ActivitiesCompanion(
            frequency: const Value('weekly'),
            selectedDays: Value(weekday),
            description: Value(description),
            chunkId: Value(chunkId),
            startTime: Value(startTime),
            endTime: Value(endTime),
            startDate: const Value.absent(),
            endDate: const Value.absent(),
          ),
        );
  }

  Future<void> updateWeeklyActivity({
    required int id,
    required String weekday,
    required int chunkId,
    required String description,
    required String frequency,
    required String startTime,
    required String endTime,
  }) async {
    await _validateActivityTimes(chunkId, startTime, endTime, excludeId: id);
    await (database.update(
      database.activities,
    )..where((a) => a.id.equals(id))).write(
      db.ActivitiesCompanion(
        id: Value(id),
        selectedDays: Value(weekday),
        chunkId: Value(chunkId),
        description: Value(description),
        frequency: Value(frequency),
        startTime: Value(startTime),
        endTime: Value(endTime),
      ),
    );
  }

  Future<void> addSeasonalActivity({
    required DateTime startDate,
    required DateTime endDate,
    required int chunkId,
    required String description,
    required String startTime,
    required String endTime,
  }) async {
    await _validateActivityTimes(chunkId, startTime, endTime);
    await database
        .into(database.activities)
        .insert(
          db.ActivitiesCompanion(
            frequency: const Value('seasonal'),
            description: Value(description),
            startDate: Value(_iso(startDate)),
            endDate: Value(_iso(endDate)),
            date: const Value.absent(),
            chunkId: Value(chunkId),
            startTime: Value(startTime),
            endTime: Value(endTime),
          ),
        );
  }

  Future<void> updateSeasonalActivity({
    required int id,
    required String startDate,
    required String endDate,
    required int chunkId,
    required String description,
    required String frequency,
    required String startTime,
    required String endTime,
  }) async {
    await _validateActivityTimes(chunkId, startTime, endTime, excludeId: id);
    await (database.update(
      database.activities,
    )..where((a) => a.id.equals(id))).write(
      db.ActivitiesCompanion(
        id: Value(id),
        startDate: Value(startDate),
        endDate: Value(endDate),
        chunkId: Value(chunkId),
        description: Value(description),
        frequency: Value(frequency),
        startTime: Value(startTime),
        endTime: Value(endTime),
      ),
    );
  }

  /* =========================
   *  COMPLETIONS
   * =========================
  */
  Future<void> setActivityCompleted(int activityId) {
    return database
        .into(database.completions)
        .insertOnConflictUpdate(
          db.CompletionsCompanion(
            activityId: Value(activityId),
            completedDate: Value(
              DateTime.now().toIso8601String().split('T')[0],
            ),
          ),
        );
  }

  Future<void> setActivityIncomplete(int activityId) {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return (database.delete(database.completions)..where(
          (c) =>
              c.activityId.equals(activityId) & c.completedDate.equals(today),
        ))
        .go();
  }

  /* =========================
   * VALIDATION
   * =========================
  */

  /// Throws a descriptive [Exception] if times are invalid.
  /// Call this before every insert/update.
  Future<void> _validateActivityTimes(
    int chunkId,
    String startTime,
    String endTime, {
    int? excludeId,
    String? excludedDescription,
  }) async {
    if (_timeToMinutes(startTime) >= _timeToMinutes(endTime)) {
      throw Exception('Start time must be before end time.');
    }

    final fits = await activityFitsInChunk(chunkId, startTime, endTime);
    if (!fits) {
      throw Exception(
        'Activity times ($startTime–$endTime) fall outside the chunk window.',
      );
    }

    final overlapping = await getOverlappingActivities(
      chunkId,
      startTime,
      endTime,
      excludeId: excludeId,
      excludedDescription: excludedDescription,
    );
    if (overlapping.isNotEmpty) {
      final uniqueDescription = overlapping
          .map((a) => a.description)
          .toSet()
          .map((d) => '"$d"')
          .join(', ');
      throw Exception(
        'Time conflicts with existing activit${overlapping.length == 1 ? 'y' : 'ies'}: $uniqueDescription',
      );
    }
  }

  /* =========================
   * HELPERS
   * =========================
  */

  String _iso(DateTime d) => d.toIso8601String().split('T').first;

  /// Converts 'HH:MM' to total minutes since midnight.
  int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}
