import "package:univid_compressor/core/stores/types/video_in_list.dart";
import "package:univid_compressor/database/database.dart";

class PreparationVideo extends VideoInList {

  PreparationVideo({required super.videoDetails, super.preset});

  @override
  void setPreset(Preset preset ) {
    super.preset_ = preset;
  }


  /// We will get the preset properties when the the video
  /// is about to get converted - so as to get the latest change.
}
