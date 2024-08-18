import "package:drift/drift.dart";
import "package:drift_flutter/drift_flutter.dart";

part "database.g.dart";

class Presets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get lastSelectedDate => dateTime()();
}

class PresetProperties extends Table {
  IntColumn get presetId => integer().references(Presets, #id)();
  RealColumn get quality => real()();
  DateTimeColumn get lastSelectedDate => dateTime()();

  @override
  Set<IntColumn>? get primaryKey => <IntColumn>{ presetId };
}

@DriftDatabase(tables: <Type>[Presets])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/getting-started/#open
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    // `driftDatabase` from `package:drift_flutter` stores the database in
    // `getApplicationDocumentsDirectory()`.
    return driftDatabase(name: "univid_database");
  }
}
