import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

@DriftDatabase(include: {'tables.drift'})
class AppDb extends _$AppDb {
  AppDb._internal() : super(_openConnection());
  static final AppDb _instance = AppDb._internal();

  factory AppDb() => _instance;

  @override
  int get schemaVersion => 2; // bump from 1 to 2

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Add the two new nullable columns to existing installs
        await m.addColumn(activities, activities.startTime);
        await m.addColumn(activities, activities.endTime);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'timely.db'));
    return NativeDatabase.createInBackground(file);
  });
}
