import "package:flutter/material.dart";
import "package:univid_compressor/core/widgets.dart";
import "package:univid_compressor/skeleton/settings/compression_settings_section.dart";
import "package:univid_compressor/skeleton/video_queue/video_queue_section.dart";

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    //TODO Add a tranition animation when this page appears 
    return const ColumnWithSpacings(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        VideoQueueSection(),
        CompressionSettingsSection(),
      ],
    );
  }
}
