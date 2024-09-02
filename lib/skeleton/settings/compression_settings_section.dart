import "package:flutter/material.dart";
import "package:univid_compressor/core/constants.dart";
import "package:univid_compressor/core/widgets.dart";
import "package:univid_compressor/core/widgets/custom_container.dart";
import "package:univid_compressor/skeleton/settings/max_framerate_radio/max_framerate_radio.dart";
import "package:univid_compressor/skeleton/settings/preset_selector/preset_selector.dart";
import "package:univid_compressor/skeleton/settings/quality_slider/quality_slider.dart";
import "package:univid_compressor/skeleton/settings/scale_factor_selector/scale_factor_selector.dart";

class CompressionSettingsSection extends StatelessWidget {
  const CompressionSettingsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kXLScreenWidth,
      child: CustomContainer(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: ColumnWithSpacings(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: <Widget>[
              Center(
                child: Text(
                  "Settings",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),

              // TODO: 1. When Editing settings value
              // TODO: Add a debounced store to db
              // TODO: So that the database keeps the last stored settings

              // TODO: 2. When Selecting a preset
              // TODO: replace the Settings with
              // TODO: with the values stored in the preset

              // TODO: 3.
              // TODO: Add presets to videos.
              // TODO: We can select multiple vidos
              // TODO: and can add a preset to multiples at the same time
              // TODO: Before each operation we check the database for its values.

              const PresetSelector(),
              const QualitySlider(),
              const ScaleFactorSelector(),
              const MaxFramerateRadio(),
            ],
          ),
        ),
      ),
    );
  }
}
