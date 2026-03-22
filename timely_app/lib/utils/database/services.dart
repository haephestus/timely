import 'package:drift/drift.dart';
//import 'package:timely_app/models/chunk.dart' as model;
import 'package:timely_app/models/chunk_activity.dart';
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
  Future<List<db.Activity>> _getActivitiesFromDb(int chunkId) {
    return database.getActivitiesByChunkId(chunkId).get();
  }

  /// Public method: maps db.Activity → ChunkActivity
  Future<List<ChunkActivity>> getActivitiesForChunk(int chunkId) async {
    final dbActivities = await _getActivitiesFromDb(chunkId);

    return dbActivities.map((a) {
      switch (a.type) {
        case 'repeatable':
          return RepeatableActivity(
            name: a.name,
            description: a.description,
            completed: a.completed == 1,
            date: DateTime.parse(a.date!),
          );
        case 'one_off':
          return OneOffActivity(
            name: a.name,
            description: a.description,
            completed: a.completed == 1,
            date: DateTime.parse(a.date!),
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
  }

  /* =========================
   * INSERT / UPDATE
   * =========================
  */

  Future<int> addRepeatableActivity({
    required String name,
    required DateTime date,
    required int chunkId,
  }) {
    return database
        .into(database.activities)
        .insert(
          db.ActivitiesCompanion(
            name: Value(name),
            type: const Value('repeatable'),
            date: Value(_iso(date)),
            chunkId: Value(chunkId),
            startDate: const Value.absent(),
            endDate: const Value.absent(),
            completed: const Value(0),
          ),
        );
  }

  Future<int> addOneOffActivity({
    required String name,
    required DateTime date,
    required int chunkId,
  }) {
    return database
        .into(database.activities)
        .insert(
          db.ActivitiesCompanion(
            name: Value(name),
            type: const Value('one_off'),
            date: Value(_iso(date)),
            chunkId: Value(chunkId),
            startDate: const Value.absent(),
            endDate: const Value.absent(),
            completed: const Value(0),
          ),
        );
  }

  Future<int> addRangeActivity({
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required int chunkId,
  }) {
    return database
        .into(database.activities)
        .insert(
          db.ActivitiesCompanion(
            name: Value(name),
            type: const Value('range'),
            startDate: Value(_iso(startDate)),
            endDate: Value(_iso(endDate)),
            date: const Value.absent(),
            chunkId: Value(chunkId),
            completed: const Value(0),
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
