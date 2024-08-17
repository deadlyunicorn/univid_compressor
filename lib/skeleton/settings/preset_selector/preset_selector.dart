import "dart:async";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/widgets.dart";
import "package:univid_compressor/database/database.dart";
import "package:univid_compressor/skeleton/settings/preset_selector/new_preset_dialog.dart";

class PresetSelector extends StatefulWidget {
  const PresetSelector({
    super.key,
  });

  @override
  State<PresetSelector> createState() => _PresetSelectorState();
}

class _PresetSelectorState extends State<PresetSelector> {
  late final AppDatabase db = context.read<AppDatabase>();

  @override
  void initState() {
    super.initState();
    db.select(db.presets).get().then((List<Preset> dbPresets) {
      setState(() {
        presets = dbPresets;
      });
    });
  }

  DropdownMenuEntry<int>? get selectedPreset => _selectedPreset;

  final TextEditingController presetTextController = TextEditingController();
  List<Preset> presets = <Preset>[];

  @override
  Widget build(BuildContext context) {
    return RowWithSpacings(
      spacing: 16,
      children: <Widget>[
        const Text("Presets"),
        Tooltip(
          message: selectedPreset?.label ?? "",
          child: DropdownMenu<int>(
            width: 192,
            controller: presetTextController,
            dropdownMenuEntries: <DropdownMenuEntry<int>>[
              const DropdownMenuEntry<int>(
                value: -1,
                label: "New Preset",
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.only(left: 16),
                  ),
                ),
                trailingIcon: Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.add,
                  ),
                ),
              ),
              ...presets.map(
                (Preset preset) => DropdownMenuEntry<int>(
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.only(left: 16),
                    ),
                  ),
                  value: preset.id,
                  label: preset.title,
                  trailingIcon: Tooltip(
                    message: "Remove preset: ${preset.title}",
                    child: IconButton(
                      onPressed: () {
                        (db.delete(db.presets)
                              ..where(
                                ($PresetsTable dbPreset) =>
                                    dbPreset.id.equals(preset.id),
                              ))
                            .go()
                            .then((_) {
                          db
                              .select(db.presets)
                              .get()
                              .then((List<Preset> dbPresets) {
                            setState(() {
                              presets = dbPresets;
                              if (selectedPreset?.value == preset.id) {
                                presetTextController.clear();
                              }
                            });
                          });
                        });
                      },
                      color: Theme.of(context).colorScheme.error,
                      icon: const Icon(
                        Icons.remove_circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            onSelected: (int? value) async {
              if (value == -1) {
                presetTextController.clear();
                unawaited(
                  showDialog<DropdownMenuEntry<int>?>(
                    context: context,
                    builder: (BuildContext _) => Provider<AppDatabase>.value(
                      value: context.read<AppDatabase>(),
                      child: const NewPresetDialog(),
                    ),
                  ).then((DropdownMenuEntry<int>? newPreset) async {
                    if (newPreset != null) {
                      final List<Preset> dbPresets =
                          await db.select(db.presets).get();
                      setState(() {
                        presets = dbPresets;
                        setSelectedPreset(newPreset);
                      });
                    }
                  }),
                );
              } else if (value != null) {
                setState(() {
                  setSelectedPreset(
                    DropdownMenuEntry<int>(
                      value: value,
                      label: presetTextController.text,
                    ),
                  );
                });
              }
            },
          ),
        ),
      ],
    );
  }

  DropdownMenuEntry<int>? _selectedPreset;
  void setSelectedPreset(DropdownMenuEntry<int> newPreset) {
    setState(() {
      _selectedPreset = newPreset;
      presetTextController.text = newPreset.label;
    });
  }
}
