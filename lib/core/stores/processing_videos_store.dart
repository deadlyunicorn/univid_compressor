import "package:flutter/material.dart";
import "package:univid_compressor/core/stores/types/processing_video.dart";

class ProcessingVideosStore extends ChangeNotifier {
  final List<ProcessingVideo> _processingVideoList = <ProcessingVideo>[];


  List<ProcessingVideo> get processingVideoList => _processingVideoList;

  int addVideos(Iterable<ProcessingVideo> candidateVideos) {
    final Iterable<String> alreadyImportedVideoFileUrls =
        processingVideoList.map(
      (ProcessingVideo alreadyImportedVideo) =>
          alreadyImportedVideo.videoDetails.fileReference.path,
    );

    final Iterable<ProcessingVideo> newVideos = candidateVideos.where(
      (ProcessingVideo candidateVideo) => !alreadyImportedVideoFileUrls
          .contains(candidateVideo.videoDetails.fileReference.path),
    );

    final int videosToBeAddedLength = newVideos.length;

    _processingVideoList.addAll(newVideos);
    notifyListeners();

    return videosToBeAddedLength;
  }
}
