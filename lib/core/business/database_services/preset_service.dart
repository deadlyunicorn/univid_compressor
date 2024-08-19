import "package:drift/drift.dart";
import "package:univid_compressor/database/database.dart";

/// Does the necessary mutations to the preset properties table.
class PresetService {
  final AppDatabase _db;
  PresetService({
    required AppDatabase database,
  }) : _db = database;

  Future<void> delete({
    required Preset presetToDelete,
  }) async {
    await _db.transaction(() async {
      final Future<int> deleteSettingPromise = (_db.delete(_db.presetProperties)
            ..where(
              ($PresetPropertiesTable settings) =>
                  settings.presetId.equals(presetToDelete.id),
            ))
          .go();
      final Future<int> deletePresetPromise = (_db.delete(_db.presets)
            ..where(
              ($PresetsTable dbPreset) => dbPreset.id.equals(presetToDelete.id),
            ))
          .go();

      await Future.wait(<Future<int?>>[
        deleteSettingPromise,
        deletePresetPromise,
      ]);
    });
  }

  Future<int> create(PresetsCompanion presetCompanion) async {
    return await _db.transaction(() async {
      final int rowId = await _db.into(_db.presets).insert(
            presetCompanion,
          );

      await _db.into(_db.presetProperties).insert(
            PresetPropertiesCompanion.insert(
              presetId: Value<int>(rowId),
            ),
          );

      return rowId;
    });
  }

  Future<void> update(PresetProperty settings) async { 

    await _db.update(_db.presetProperties).replace(settings);
  }
}
