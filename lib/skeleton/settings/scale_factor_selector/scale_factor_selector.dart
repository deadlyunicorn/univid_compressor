import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/stores/preset_store.dart";
import "package:univid_compressor/core/widgets/small_radio_selector.dart";
import "package:univid_compressor/database/consts.dart";

class ScaleFactorSelector extends StatelessWidget {
  const ScaleFactorSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SmallRadioSelector<double>(
      title: "Downscale Factor: ",
      valueMap: scaleFactors,
      selectedValue: context.watch<PresetStore>().settings.scaleFactor,
      onChanged: (double? value) {
        context.read<PresetStore>().setSettings(scaleFactor: value);
      },
    );
  }
}
