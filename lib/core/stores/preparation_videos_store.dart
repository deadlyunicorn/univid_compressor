import "package:flutter/material.dart";
import "package:univid_compressor/database/database.dart";
import "package:univid_compressor/skeleton/video_queue/preparation/preparation_video.dart";

class PreparationVideosStore extends ChangeNotifier {
  List<PreparationVideo> _preparationVideoList = <PreparationVideo>[];
  List<PreparationVideo> get preparationVideoList => _preparationVideoList;

  ///Returns new videos that should have been added.
  int addVideos(Iterable<PreparationVideo> candidateVideos) {
    final Iterable<String> alreadyImportedVideoFileUrls =
        preparationVideoList.map(
      (PreparationVideo alreadyImportedVideo) =>
          alreadyImportedVideo.videoDetails.fileReference.path,
    );

    final Iterable<PreparationVideo> newVideos = candidateVideos.where(
      (PreparationVideo candidateVideo) => !alreadyImportedVideoFileUrls
          .contains(candidateVideo.videoDetails.fileReference.path),
    );

    final int videosToBeAddedLength = newVideos.length;

    preparationVideoList.addAll(newVideos);
    notifyListeners();

    return videosToBeAddedLength;
  }

  void selectAll() {
    final List<PreparationVideo> newVideoList = preparationVideoList
        .map((PreparationVideo video) => video..isSelected = true)
        .toList();

    _preparationVideoList = newVideoList;
    notifyListeners();
  }

  void unselectAll() {
    final List<PreparationVideo> newVideoList = preparationVideoList
        .map((PreparationVideo video) => video..isSelected = false)
        .toList();

    _preparationVideoList = newVideoList;

    notifyListeners();
  }

  void removeSelected() {
    final List<PreparationVideo> newVideoList = preparationVideoList
        .where(
          (PreparationVideo element) => !element.isSelected,
        )
        .toList();
    _preparationVideoList = newVideoList;
    notifyListeners();
  }

  void setPresetForSelected({required Preset preset}) {
    final List<PreparationVideo> newVideoList = preparationVideoList
        .map(
          (PreparationVideo video) => video.isSelected
              ? (video
                ..preset = preset
                ..isSelected = false)
              : video,
        )
        .toList();
    _preparationVideoList = newVideoList;
    notifyListeners();
  }

  void updatePreparationVideo({
    required PreparationVideo newPreparationVideo,
    required int index,
  }) {
    _preparationVideoList[index] = newPreparationVideo;
    notifyListeners();
  }
}
