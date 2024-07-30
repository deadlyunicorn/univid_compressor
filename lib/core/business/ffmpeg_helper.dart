import "dart:io";

import "package:flutter/material.dart";
import "package:univid_compressor/core/business/univid_filesystem.dart";
import "package:univid_compressor/extensions/file.dart";

class FFMpegController with ChangeNotifier {
  //TODO Getter for FFMPeg type that we are using

  FFmpegSetup? _setup;

  FFmpegSetup get setup {
    if (_setup == null) {
      _setup = FFmpegSetup();
      return _setup!;
    } else {
      return _setup!;
    }
  }

  bool _ffmpegExists = false;
  bool get ffmpegExists => _ffmpegExists;
  late final FFMpegType _ffmpegType;

  SetupError? _setupError;
  SetupError? get setupError => _setupError;

  set setupError(SetupError? newState) {
    _setupError = newState;
    notifyListeners();
  }

  set ffmpegExists(bool newValue) {
    _ffmpegExists = newValue;
    notifyListeners();
  }

  FFMpegController.initialize() {
    if (Platform.isAndroid || Platform.isIOS) {
      ffmpegExists = true;
      _ffmpegType = FFMpegType.ffmpegKit;
    } else if (Platform.isLinux) {
      final int exitCode =
          Process.runSync("ffmpeg", <String>[], runInShell: true).exitCode;
      if (exitCode == 1 &&
          !const bool.fromEnvironment(
            "TESTING_STATIC_FFMPEG",
            defaultValue: false,
          )) {
        _ffmpegType = FFMpegType.nativeBinaries;
        ffmpegExists = true;
      } else {
        checkForStaticBinaries();
      }
    } else {
      setupError = SetupError.invalidPlatform;
    }
  }

  Future<void> checkForStaticBinaries() async {
    final String path = (await UnividFilesystem.ffmpegDir).path;
    final bool canExecuteFFmpeg = await Process.run(
      "$path/ffmpeg",
      <String>[],
      runInShell: true,
    ).then((ProcessResult value) => value.exitCode == 1);
    if (canExecuteFFmpeg) //?exists
    {
      ffmpegExists = true;
      _ffmpegType = FFMpegType.staticBinaries;
      notifyListeners();
    }
  }

  Future<bool> execute({
    required List<String> arguments,
    required File inputFile,
    required File outputFile,
  }) async {
    switch (_ffmpegType) {
      case FFMpegType.ffmpegKit:
        throw UnimplementedError(); // TODO
      case FFMpegType.nativeBinaries:
        final Process ffmpegProcess = await Process.start(
          "ffmpeg",
          <String>["-i", inputFile.path, ...arguments, outputFile.path],
        );

        //? FFMPEG outputs only to stderr

        await ffmpegProcess.stderr.forEach(
          (List<int> data) {
            final String parsedData = String.fromCharCodes(data);
            if (parsedData.contains("frame")) {
              if (parsedData.contains("fps")) {
                final int? currentFrame = int.tryParse(
                  parsedData
                      .substring(
                        parsedData.indexOf("frame"),
                        parsedData.indexOf("fps"),
                      )
                      .replaceAll(" ", "")
                      .split("=")[1],
                );
                print("Progress ( Current frame: $currentFrame)");
                //? Can be used to track progress if we know the duration
                //? and fps of the target video..
                // TODO
              }
            }

            //TODO move those to a separate error detecting function 
            //? As FFMPeg kit might return similar outputs.
            if (parsedData.contains("already exists.")) {
              throw "File already exists";
            } else if (parsedData
                .contains("Invalid data found when processing input")) {
              throw "Corrupted file";
            } else if (parsedData.contains("No such file or directory")) {
              throw "Original file not found";
            }
          },
        );

        await outputFile.copyOriginalFileDetails(inputFile);
        return true;

      case FFMpegType.staticBinaries:
        throw UnimplementedError(); // TODO
    }
  }
}

class FFmpegSetup {}

class FFMpegHelper {}

enum SetupError {
  invalidPlatform,
  connectionError,
}

/// 1. ffmpegKit<br>
/// 2. nativeBinaries: can execute from terminal<br>
/// 3. staticBinaries: we have downloaded the zip from the official to document
enum FFMpegType {
  ffmpegKit,
  nativeBinaries, //? can execute from terminal
  staticBinaries //? we have downloaded the zip from the official to documents
}
