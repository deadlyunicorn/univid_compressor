import "package:univid_compressor/core/stores/types/processing_video.dart";
import "package:univid_compressor/core/stores/types/video_list.dart";

class ProcessingVideosStore
    extends AbstractVideoListChangeNotifier<ProcessingVideo> {
  List<ProcessingVideo> get processingVideoList => super.videoList;
}
