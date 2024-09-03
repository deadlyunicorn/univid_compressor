import "package:univid_compressor/core/video_details.dart";
import "package:univid_compressor/database/database.dart";

class ProcessingVideo {
  ProcessingVideo({
    required this.videoDetails,
    required this.preset,
  });

  VideoDetails videoDetails;
  Preset preset;

  /// values between 0 and 1
  double? progress;

  //TODO: implement methods for
  //* 1. Moving the pending video from Processing back to Preparation ( for Preset change)
  //* 2. Moving the completed video ( the original ) ^^^^^^^^^^
  //* 3. Moving the completed video result ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
}
