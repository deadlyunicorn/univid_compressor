import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:univid_compressor/core/stores/processing_videos_store.dart";
import "package:univid_compressor/core/stores/types/processing_video.dart";
import "package:univid_compressor/skeleton/video_queue/list_container.dart";

class ProcessingList extends StatelessWidget {
  const ProcessingList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isEmpty = true;
    final List<ProcessingVideo> processingVideoList =
        context.watch<ProcessingVideosStore>().processingVideoList;
    return ListContainer(
      //TODO HERE
      child: processingVideoList.isEmpty
          ? const Center(child: Text("No videos to convert"))
          : Column(
              children: <Widget>[Text("${processingVideoList.length} videos")],
            ),
    );
  }
}
