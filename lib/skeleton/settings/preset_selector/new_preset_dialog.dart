import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/widgets/univid_dialog.dart";
import "package:univid_compressor/database/database.dart";

class NewPresetDialog extends StatefulWidget {
  const NewPresetDialog({
    super.key,
  });

  @override
  State<NewPresetDialog> createState() => _NewPresetDialogState();
}

class _NewPresetDialogState extends State<NewPresetDialog> {
  final TextEditingController presetTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return UnividDialog<Preset>(
      content: TextField(
        maxLines: 4,
        minLines: 1,
        controller: presetTextController,
      ),
      onConfirm: () async {
        final AppDatabase db = context.read<AppDatabase>();
        final DateTime selectedDate = DateTime.now();
        final int rowId = await db.into(db.presets).insert(
              PresetsCompanion.insert(
                title: presetTextController.text,
                lastSelectedDate: selectedDate,
              ),
            );
        return Preset(
          id: rowId,
          title: presetTextController.text,
          lastSelectedDate: selectedDate,
        );
      },
      title: const Text("Enter the name of the new Preset:"),
    );
  }
}