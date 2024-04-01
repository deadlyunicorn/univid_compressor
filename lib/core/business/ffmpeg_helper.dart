import "dart:io";

import "package:flutter/material.dart";

class FFMpegController with ChangeNotifier {

  //TODO Getter for FFMPeg type that we are using

  bool _binaryExists = false;
  bool get binaryExists => _binaryExists;

  void setBinaryExists(bool newValue) {
    _binaryExists = newValue;
    notifyListeners();
  }

  FFMpegController.initialize() {
    if (Platform.isAndroid) {
      setBinaryExists(true);
    }
  }
}

class FFMpegHelper {


}

enum FFMpegType {
  ffmpegKit,
  nativeBinaries, //? can execute from terminal
  staticBinaries //? we have downloaded the zip from the official to documents
}