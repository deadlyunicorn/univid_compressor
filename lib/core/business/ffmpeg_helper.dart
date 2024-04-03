import "dart:io";

import "package:flutter/material.dart";
import "package:univid_compressor/core/business/univid_filesystem.dart";

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
  FFMpegType ffmpegType = FFMpegType.ffmpegKit;

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
      ffmpegType = FFMpegType.ffmpegKit;
    } else if (Platform.isLinux) {
      final int exitCode =
          Process.runSync("ffmpeg", <String>[], runInShell: true).exitCode;
      if (exitCode == 1 &&
          !const bool.fromEnvironment(
            "TESTING_STATIC_FFMPEG",
            defaultValue: false,
          )) {
        ffmpegType = FFMpegType.nativeBinaries;
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
      ffmpegType = FFMpegType.staticBinaries;
      notifyListeners();
    }
  }
}

class FFmpegSetup {}

class FFMpegHelper {}

enum SetupError {
  invalidPlatform,
  connectionError,
}

enum FFMpegType {
  ffmpegKit,
  nativeBinaries, //? can execute from terminal
  staticBinaries //? we have downloaded the zip from the official to documents
}
