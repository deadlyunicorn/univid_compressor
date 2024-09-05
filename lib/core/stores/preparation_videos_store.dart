import "package:univid_compressor/core/stores/types/preparation_video.dart";
import "package:univid_compressor/core/stores/types/video_list.dart";

class PreparationVideosStore
    extends AbstractVideoListChangeNotifier<PreparationVideo> {
  List<PreparationVideo> get preparationVideoList => super.videoList;
}
