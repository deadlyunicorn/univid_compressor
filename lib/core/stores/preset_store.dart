import "dart:async";

import "package:drift/drift.dart";
import "package:flutter/material.dart";
import "package:univid_compressor/core/business/database_services/preset_service.dart";
import "package:univid_compressor/database/database.dart";

class PresetStore extends ChangeNotifier {
  PresetStore({required AppDatabase database}) : _database = database;

  final AppDatabase _database;
  Preset? get selectedPreset => _selectedPreset;

  /// Returns the selected preset
  Future<Preset> setSelectedPreset(Preset newlySelectedPreset) async {
    await (_database.update(_database.presets)
          ..where(
            ($PresetsTable preset) => preset.id.equals(newlySelectedPreset.id),
          ))
        .write(
      PresetsCompanion(
        lastSelectedDate: Value<DateTime>(DateTime.now()),
      ),
    );

    if (newlySelectedPreset.id != settings.presetId) {
      await loadSettingsFromPreset(preset: newlySelectedPreset);
    }
    _selectedPreset = Preset(
      id: newlySelectedPreset.id,
      title: newlySelectedPreset.title,
      lastSelectedDate: DateTime.now(),
    );

    notifyListeners();
    return _selectedPreset!;
  }

  Preset? _selectedPreset;

  //? Settings Related Section
  PresetProperty settings = const PresetProperty(
    presetId: -1,
    quality: 1,
  );

  /// Returns true if settings were successfully updated.
  Future<void> saveSettings() async {
    final int? presetIdToUpdate = selectedPreset?.id;

    if (presetIdToUpdate == null) {
      return;
    }

    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      PresetService(database: _database).update(settings);
    });
  }

  Future<void> loadSettingsFromPreset({required Preset preset}) async {
    final PresetProperty dbSettings =
        await (_database.select(_database.presetProperties)
              ..where(
                ($PresetPropertiesTable dbPreset) =>
                    dbPreset.presetId.equals(preset.id),
              ))
            .getSingle();
    settings = dbSettings;
    notifyListeners();
  }

  void setSettings({double? quality}) {
    //TODO: ETC, fill in the rest properties.

    settings = PresetProperty(
      presetId: settings.presetId,
      quality: quality ?? settings.quality,
    );
    notifyListeners();
    saveSettings();
  }

  Timer? _debounce;
}
