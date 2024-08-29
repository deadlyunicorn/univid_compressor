import "package:univid_compressor/core/video_details.dart";
import "package:univid_compressor/database/database.dart";

class QueuedVideo {
  QueuedVideo({required this.videoDetails});

  VideoDetails videoDetails;

  /// We will get the preset properties when the the video
  /// is about to get converted - so as to get the latest change.
  Preset? preset;
  bool isSelected = false;
}
