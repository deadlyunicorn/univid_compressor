import "package:flutter/material.dart";
import "package:univid_compressor/core/constants.dart";
import "package:univid_compressor/core/widgets.dart";
import "package:univid_compressor/skeleton/settings/compression_settings_section.dart";
import "package:univid_compressor/skeleton/video_queue/video_queue_section.dart";

class Skeleton extends StatelessWidget {
  const Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
  
    return const Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: k3XLScreenWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16),
              child: ColumnWithSpacings(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  VideoQueueSection(),
                  CompressionSettingsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
