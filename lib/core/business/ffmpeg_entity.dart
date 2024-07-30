import "dart:io";

import "package:univid_compressor/core/business/ffmpeg_helper.dart";
import "package:univid_compressor/core/video_details.dart";

class VideoEntity {
  VideoDetails video;
  final FFMpegController _ffmpegController;
  final String _initialFileName;
  int _operationCount = 1;

  /// Provided by user - should not include file extension
  final String? _outputFileName; //TODO - if not null over write

  String get outputFileName {
    return _outputFileName ??
        // ignore: lines_longer_than_80_chars
        "${_initialFileName.substring(0, _initialFileName.indexOf('.'))}_$_operationCount";
  }

  String get outputFilePath =>
      "${video.fileReference.parent.path}/$outputFileName.mp4";

  VideoEntity({
    required VideoDetails initialVideo,
    required FFMpegController controller,
    String? outputFileName,
  })  : video = initialVideo,
        _ffmpegController = controller,
        _initialFileName = initialVideo.fileReference.path
            .replaceFirst("${initialVideo.fileReference.parent.path}/", ""),
        _outputFileName = outputFileName;

  //TODO All those operations should return a new VideoEntity
  //TODO so that they can be chained

  // e.g. await video.changeScale()

  Future<VideoDetails> changeScale({required int divideBy}) async {
    await _execute(
      arguments: <String>["-vf", "scale=iw/$divideBy:ih/$divideBy"],
    );
    return video;
    throw UnimplementedError(); //TODO
  }

  Future<VideoDetails> changeQuality({
    required int qualityLossPercentage,
  }) async {
    await _execute(arguments: <String>[]);
    throw UnimplementedError(); //TODO
  }

  Future<VideoDetails> changeFramerate({required int fps}) async {
    throw UnimplementedError(); //TODO
  }

  Future<VideoDetails> _execute({required List<String> arguments}) async {
    final File newFile = File(outputFilePath);
    await _ffmpegController.execute(
      arguments: arguments,
      inputFile: video.fileReference,
      outputFile: newFile,
    );
    _operationCount++;

    return VideoDetails(
        sizeInBytes: newFile.lengthSync(),
        name: "$outputFileName.mp4",
        fileReference: newFile,);


  }
}
