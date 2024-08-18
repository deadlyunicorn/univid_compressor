import "dart:async";

import "package:flutter/material.dart";
import "package:univid_compressor/database/database.dart";

/// Settings == PresetProperties
class SettingsStore extends ChangeNotifier {
  //TODO: Move this inside PresetStore
  SettingsStore({required AppDatabase database}) : _database = database;

  PresetProperty settings = PresetProperty(
      presetId: -1, quality: 1, lastSelectedDate: DateTime.now()); //TODO
  int? presetId;

  /// Returns true if settings were successfully updated.
  Future<void> updateSettings() async {
    final int? presetIdToUpdate = presetId;

    print("Timer started");

    if (presetIdToUpdate == null) {
      return;
    }

    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      print(" Should update settings now ");
      _database.update(_database.presetProperties).replace(settings).then(
        (bool _) {
          //TODO: Rmeove
        },
      ); // TODO
    });
  }

  void setProperty({double? quality}) {
    //TODO: ETC.

    print("New: $quality");
    settings = PresetProperty(
      presetId: settings.presetId,
      quality: quality ?? settings.quality,
      lastSelectedDate: settings.lastSelectedDate,
    );
          notifyListeners();

    updateSettings();
  }

  Timer? _debounce;
  final AppDatabase _database;
}


//TODO: Should get the settings as well
//! And write them to the db - 
//! so that when we select the Preset,
//! it has stored them.
