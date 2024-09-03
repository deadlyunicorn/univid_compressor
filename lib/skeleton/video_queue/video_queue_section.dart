import "dart:math";

import "package:flutter/material.dart";
import "package:nested/nested.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/constants.dart";
import "package:univid_compressor/core/stores/preparation_videos_store.dart";
import "package:univid_compressor/core/stores/processing_videos_store.dart";
import "package:univid_compressor/core/widgets.dart";
import "package:univid_compressor/skeleton/video_queue/preparation/video_preparation_list.dart";
import "package:univid_compressor/skeleton/video_queue/processing/processing_list.dart";
import "package:univid_compressor/skeleton/video_queue/start_converting_selected_button.dart";

class VideoQueueSection extends StatelessWidget {
  const VideoQueueSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<PreparationVideosStore>(
          create: (BuildContext context) => PreparationVideosStore(),
        ),
        ChangeNotifierProvider<ProcessingVideosStore>(
          create: (BuildContext context) => ProcessingVideosStore(),
        ),
      ],
      child: SizedBox(
        height:
            max(MediaQuery.sizeOf(context).height * 0.7, kMediumScreenWidth),
        child: const RowWithSpacings(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          spacing: 16,
          children: <Widget>[
            VideoPreparationList(),
            StartConvertingSelectedButton(),
            ProcessingList(),
          ],
        ),
      ),
    );
  }
}
