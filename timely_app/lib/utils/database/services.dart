import 'package:drift/drift.dart';
//import 'package:timely_app/models/chunk.dart' as model;
import 'package:timely_app/models/chunk_activity.dart';
import 'package:timely_app/utils/calendar_utils.dart';
import 'package:timely_app/utils/database/database.dart' as db;

class ChunkActivityService {
  final db.AppDb database;

  ChunkActivityService(this.database);

  /* =========================
   * CHUNKS
   * ========================= 
  */

  Future<List<db.Chunk>> getAllChunks() => database.getAllChunks().get();

  Future<List<db.Chunk>> getActiveChunks() => database.getActiveChunks().get();

  Future<db.Chunk?> getChunkByName(String name) =>
      database.getChunkInfoByChunkName(name).getSingleOrNull();

  /* =========================
   * ACTIVITIES
   * ========================= 
  */

  /// Raw DB fetch (internal)
  Future<List<db.Activity>> _getActivitiesFromDb(int chunkId, DateTime date) {
    final dateStr = date.toIso8601String().split('T')[0]; // "2026-03-27"
    return database.getActivitiesByChunkId(chunkId, dateStr).get();
  }

  /// Public method: maps db.Activity → ChunkActivity
  Future<List<ChunkActivity>> getActivitiesForChunk(
    int chunkId,
    DateTime date,
  ) async {
    final dbActivities = await _getActivitiesFromDb(chunkId, date);
    return dbActivities.map((a) {
      switch (a.type) {
        case 'everyday':
          return EverydayActivity(
            name: a.name,
            description: a.description,
            completed: a.completed == 1,
            date: DateTime.parse(a.date!),
          );
        case 'periodic':
          return PeriodicActivity(
            name: a.name,
            description: a.description,
            completed: a.completed == 1,
            weekday: a.weekday?.split(',') ?? [],
          );
        case 'range':
          return RangeActivity(
            name: a.name,
            description: a.description,
            completed: a.completed == 1,
            startDate: DateTime.parse(a.startDate!),
            endDate: DateTime.parse(a.endDate!),
          );
        default:
          throw Exception('Unknown activity type: ${a.type}');
      }
    }).toList();
  } /* =========================
   * INSERT / UPDATE
   * =========================
  */

  Future<void> addEverydayActivity({
    required String name,
    required int chunkId,
    required String description,
  }) async {
    await database.batch((b) {
      for (
        var d = DateTime.now();
        !d.isAfter(kLastDay);
        d = d.add(const Duration(days: 1))
      ) {
        b.insert(
          database.activities,
          db.ActivitiesCompanion(
            name: Value(name),
            type: const Value('everyday'),
            date: Value(_iso(d)),
            description: Value(description),
            chunkId: Value(chunkId),
            startDate: const Value.absent(),
            endDate: const Value.absent(),
            completed: const Value(0),
          ),
        );
      }
    });
  }

  Future<void> updateEverydayActivity({
    required int id,
    required String name,
    required String date,
    required int chunkId,
    required String type,
    required String description,
  }) async {
    await database.batch((b) {
      b.update(
        database.activities,
        db.ActivitiesCompanion(
          name: Value(name),
          description: Value(description),
          type: Value(type),
        ),
        where: (tbl) => tbl.chunkId.equals(chunkId) & tbl.type.equals(type),
      );
    });
  }

  Future<void> addPeriodicActivity({
    required String name,
    required String weekday,
    required int chunkId,
    required String description,
  }) {
    return database
        .into(database.activities)
        .insert(
          db.ActivitiesCompanion(
            name: Value(name),
            type: const Value('periodic'),
            weekday: Value(weekday),
            description: Value(description),
            chunkId: Value(chunkId),
            startDate: const Value.absent(),
            endDate: const Value.absent(),
            completed: const Value(0),
          ),
        );
  }

  Future<void> updatePeriodicActivity({
    required int id,
    required String name,
    required String weekday,
    required int chunkId,
    required String description,
    required String type,
  }) async {
    await (database.update(database.activities)
      ..where((a) => a.id.equals(id))).write(
      db.ActivitiesCompanion(
        id: Value(id),
        name: Value(name),
        weekday: Value(weekday),
        chunkId: Value(chunkId),
        description: Value(description),
        type: Value(type),
      ),
    );
  }

  Future<void> addRangeActivity({
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required int chunkId,
    required String description,
  }) {
    return database
        .into(database.activities)
        .insert(
          db.ActivitiesCompanion(
            name: Value(name),
            type: const Value('range'),
            description: Value(description),
            startDate: Value(_iso(startDate)),
            endDate: Value(_iso(endDate)),
            date: const Value.absent(),
            chunkId: Value(chunkId),
            completed: const Value(0),
          ),
        );
  }

  Future<void> updateRangeActivity({
    required int id,
    required String name,
    required String startDate,
    required String endDate,
    required int chunkId,
    required String description,
    required String type,
  }) async {
    await (database.update(database.activities)
      ..where((a) => a.id.equals(id))).write(
      db.ActivitiesCompanion(
        id: Value(id),
        name: Value(name),
        startDate: Value(startDate),
        endDate: Value(endDate),
        chunkId: Value(chunkId),
        description: Value(description),
        type: Value(type),
      ),
    );
  }

  Future<void> setActivityCompleted(int activityId, bool completed) {
    return (database.update(database.activities)..where(
      (a) => a.id.equals(activityId),
    )).write(db.ActivitiesCompanion(completed: Value(completed ? 1 : 0)));
  }

  /* =========================
   * HELPERS
   * ========================= 
  */

  String _iso(DateTime d) => d.toIso8601String().split('T').first;
}
