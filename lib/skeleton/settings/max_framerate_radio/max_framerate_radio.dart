import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/stores/preset_store.dart";
import "package:univid_compressor/core/widgets/small_radio_selector.dart";
import "package:univid_compressor/database/consts.dart";

class MaxFramerateRadio extends StatelessWidget {
  const MaxFramerateRadio({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late final int maxFramerate =
        context.watch<PresetStore>().settings.maxFramerate;
    return SmallRadioSelector<int>(
      title: "Max framerate: ",
      valueMap: framerateValues,
      onChanged: (int? value) {
        context.read<PresetStore>().setSettings(maxFramerate: value);
      },
      selectedValue: maxFramerate,
    );
  }
}
