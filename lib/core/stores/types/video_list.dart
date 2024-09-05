import "package:flutter/material.dart";
import "package:univid_compressor/core/stores/types/video_in_list.dart";
import "package:univid_compressor/database/database.dart";

abstract class AbstractVideoListChangeNotifier<T extends VideoInList>
    extends ChangeNotifier {
  List<T> _videoList = <T>[];
  List<T> get videoList => _videoList;

  ///Returns new videos that should have been added.
  void addVideos(Iterable<T> candidateVideos) {
    final List<String> alreadyImportedVideoFileUrls = videoList
        .map(
          (T alreadyImportedVideo) =>
              alreadyImportedVideo.videoDetails.fileReference.path,
        )
        .toList();

    //STEP 1: Find old videos that were added again by filepath
    // if the candidateVideo has a preset, then replace it and move it
    // to the beginning of the list.
    for (int i = 0; i < candidateVideos.length; i++) {
      final T candidateVideo = candidateVideos.elementAt(i);

      final int indexOfVideo = alreadyImportedVideoFileUrls
          .indexOf(candidateVideo.videoDetails.fileReference.path);

      if (indexOfVideo != -1) {
        final T removedVideo = _videoList.removeAt(indexOfVideo);
        alreadyImportedVideoFileUrls.insert(
          0,
          alreadyImportedVideoFileUrls.removeAt(indexOfVideo),
        );
        _videoList.insert(
          0,
          candidateVideo.preset != null ? candidateVideo : removedVideo,
        );
      } else {
        alreadyImportedVideoFileUrls.insert(
          0,
          candidateVideo.videoDetails.fileReference.path,
        );
        _videoList.insert(0, candidateVideo);
      }
    }

    notifyListeners();
  }

  void selectAll() {
    final List<T> newVideoList =
        videoList.map((T video) => video..isSelected = true).toList();

    _videoList = newVideoList;
    notifyListeners();
  }

  void unselectAll() {
    final List<T> newVideoList =
        videoList.map((T video) => video..isSelected = false).toList();

    _videoList = newVideoList;

    notifyListeners();
  }

  void removeSelected() {
    final List<T> newVideoList = videoList
        .where(
          (T element) => !element.isSelected,
        )
        .toList();
    _videoList = newVideoList;
    notifyListeners();
  }

  void setPresetForSelected({required Preset preset}) {
    final List<T> newVideoList = videoList.map((T video) {
      if (video.isSelected) {
        video.setPreset(preset);
      }
      return video;
    }).toList();
    _videoList = newVideoList;
    notifyListeners();
  }

  void updateVideo({
    required T newVideo,
    required int index,
  }) {
    _videoList[index] = newVideo;
    notifyListeners();
  }

  Iterable<T> moveWherePresetExists() {
    final Iterable<T> videosToMove =
        videoList.where((T video) => video.preset != null);
    _videoList = videoList.where((T video) => video.preset == null).toList();
    notifyListeners();
    return videosToMove;
  }

  Iterable<T> moveWhereSelected() {
    final Iterable<T> videosToMove =
        videoList.where((T video) => video.isSelected);
    _videoList = videoList.where((T video) => !video.isSelected).toList();
    notifyListeners();
    return videosToMove;
  }
}
