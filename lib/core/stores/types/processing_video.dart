import "package:univid_compressor/core/errors/exceptions.dart";
import "package:univid_compressor/core/stores/types/video_in_list.dart";
import "package:univid_compressor/database/database.dart";

class ProcessingVideo extends VideoInList {
  ProcessingVideo({
    required super.videoDetails,
    required super.preset,
  });

  /// values between 0 and 1
  double? progress;
  ProcessStatus status = ProcessStatus.ready;

  @override
  void setPreset(Preset preset) {
    throw NotAllowedException();
  }

  //TODO: implement methods for
  //* 1. Moving the pending video from Processing back to Preparation ( for Preset change)
  //* 2. Moving the completed video ( the original ) ^^^^^^^^^^
  //* 3. Moving the completed video result ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
}

enum ProcessStatus { ready, pending, finished, failed }
