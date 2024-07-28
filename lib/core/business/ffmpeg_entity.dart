import "dart:io";

import "package:univid_compressor/core/business/ffmpeg_helper.dart";
import "package:univid_compressor/core/video_details.dart";

class VideoEntity {
  VideoDetails video;
  final FFMpegController _ffmpegController;
  final String _initialFileName;
  int _operationCount = 0;

  /// Provided by user - should not include file extension
  final String? _outputFileName;

  String get outputFileName {
    return _outputFileName ??
        // ignore: lines_longer_than_80_chars
        "${_initialFileName.substring(0, _initialFileName.indexOf('.'))}_${++_operationCount}";
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

  Future<bool> changeQuality({
    required int qualityLossPercentage,
  }) async {
    await _execute(arguments: <String>[]);
    throw UnimplementedError(); //TODO
  }

  Future<bool> changeFramerate({required int fps}) async {
    throw UnimplementedError(); //TODO
  }

  Future<bool> _execute({required List<String> arguments}) async {
    print(outputFilePath);
    final newFile = File(outputFilePath);
    await _ffmpegController.execute(
      arguments: arguments,
      inputFile: video.fileReference,
      outputFile: newFile,
    );

    video = VideoDetails(
        sizeInBytes: newFile.lengthSync(),
        name: "$outputFileName.mp4",
        fileReference: newFile);

    print("NEW FILE IS ");
    print(video.fileNameShort);

    return true;

    //TODO - change the currentVideo to the result of this operation.
    throw UnimplementedError();
  }
}
