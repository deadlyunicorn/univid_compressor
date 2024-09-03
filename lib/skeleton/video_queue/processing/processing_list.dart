import "package:flutter/material.dart";
import "package:univid_compressor/skeleton/video_queue/list_container.dart";

class ProcessingList extends StatelessWidget {
  const ProcessingList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isEmpty = true;

    return ListContainer(
      //TODO HERE
      child: isEmpty
          ? const Center(child: Text("No videos to convert"))
          : const Column(),
    );
  }
}
