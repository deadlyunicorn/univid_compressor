import "package:flutter/material.dart";
import "package:univid_compressor/skeleton/video_queue/list_container.dart";

class CompletedProcessingList extends StatelessWidget {
  const CompletedProcessingList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isEmpty = true;

    return ListContainer(
      //TODO HERE
      child: isEmpty
          ? const Center(child: Text("No videos converted"))
          : const Column(),
    );
  }
}
