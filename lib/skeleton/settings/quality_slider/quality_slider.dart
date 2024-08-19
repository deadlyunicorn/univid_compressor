import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/stores/preset_store.dart";
import "package:univid_compressor/core/widgets.dart";

class QualitySlider extends StatelessWidget {
  const QualitySlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double quality = context.watch<PresetStore>().settings.quality;

    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: ColumnWithSpacings(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Quality: ${(quality * 100).toStringAsFixed(2)} %",
            ),
            Slider(
              min: 0.2,
              activeColor: Theme.of(context).colorScheme.secondary,
              value: quality,
              onChanged: (double value) {
                context.read<PresetStore>().setSettings(quality: value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
