import "package:flutter/material.dart";
import "package:univid_compressor/core/constants.dart";
import "package:univid_compressor/core/widgets.dart";
import "package:univid_compressor/skeleton/settings/preset_selector/preset_selector.dart";
import "package:univid_compressor/skeleton/settings/quality_slider/quality_slider.dart";
import "package:univid_compressor/skeleton/video_queue/list_container.dart";

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

            
              const PresetSelector(),
              const QualitySlider(),
            ],
          ),
        ),
      ),
    );
  }
}
