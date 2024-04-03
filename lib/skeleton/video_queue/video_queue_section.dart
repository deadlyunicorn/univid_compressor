import "dart:math";

import "package:flutter/material.dart";
import "package:univid_compressor/core/constants.dart";
import "package:univid_compressor/core/widgets.dart";
import "package:univid_compressor/skeleton/video_queue/completed/completed_processing_list.dart";
import "package:univid_compressor/skeleton/video_queue/pending/video_queue_list.dart";
import "package:univid_compressor/skeleton/video_queue/start_converting_selected_button.dart";

class VideoQueueSection extends StatelessWidget {
  const VideoQueueSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: max(MediaQuery.sizeOf(context).height * 0.7, kMediumScreenWidth),
      child: const RowWithSpacings(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        spacing: 16,
        children: <Widget>[
          VideoQueueList(),
          StartConvertingSelectedButton(),
          CompletedProcessingList(),
        ],
      ),
    );
  }
}
