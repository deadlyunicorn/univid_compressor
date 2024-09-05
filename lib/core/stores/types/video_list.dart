import "package:flutter/material.dart";
import "package:univid_compressor/core/stores/types/video_in_list.dart";
import "package:univid_compressor/database/database.dart";

abstract class AbstractVideoListChangeNotifier<T extends VideoInList>
    extends ChangeNotifier {
  List<T> _videoList = <T>[];
  List<T> get videoList => _videoList;

  ///Returns new videos that should have been added.
  int addVideos(Iterable<T> candidateVideos) {
    final Iterable<String> alreadyImportedVideoFileUrls = videoList.map(
      (T alreadyImportedVideo) =>
          alreadyImportedVideo.videoDetails.fileReference.path,
    );

    final Iterable<T> newVideos = candidateVideos.where(
      (T candidateVideo) => !alreadyImportedVideoFileUrls
          .contains(candidateVideo.videoDetails.fileReference.path),
    );

    final int videosToBeAddedLength = newVideos.length;

    videoList.addAll(newVideos);
    notifyListeners();

    return videosToBeAddedLength;
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
        return video..isSelected = false;
      } else {
        return video;
      }
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
}
