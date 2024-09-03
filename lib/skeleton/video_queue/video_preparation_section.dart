import "dart:math";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/constants.dart";
import "package:univid_compressor/core/stores/preparation_videos_store.dart";
import "package:univid_compressor/core/widgets.dart";
import "package:univid_compressor/skeleton/video_queue/preparation/video_preparation_list.dart";
import "package:univid_compressor/skeleton/video_queue/processing/processing_list.dart";
import "package:univid_compressor/skeleton/video_queue/start_converting_selected_button.dart";

class VideoPreparationSection extends StatelessWidget {
  const VideoPreparationSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PreparationVideosStore>(
      create: (BuildContext context) => PreparationVideosStore(),
      child: Consumer<PreparationVideosStore>(
        builder:
            (BuildContext context, PreparationVideosStore notifier, Widget? child) =>
                SizedBox(
          height:
              max(MediaQuery.sizeOf(context).height * 0.7, kMediumScreenWidth),
          child: RowWithSpacings(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            spacing: 16,
            children: <Widget>[
              VideoPreparationList(
                preparationVideoList: notifier.preparationVideoList,
              ),
              const StartConvertingSelectedButton(),
              const ProcessingList(),
            ],
          ),
        ),
      ),
    );
  }
}
