import "package:drift/drift.dart";
import "package:flutter/material.dart";
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

    notifyListeners();
    return Preset(
      id: newlySelectedPreset.id,
      title: newlySelectedPreset.title,
      lastSelectedDate: DateTime.now(),
    );
  }

  Preset? _selectedPreset;
}
