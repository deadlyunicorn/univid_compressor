import "dart:io";
import "dart:math";

import "package:univid_compressor/core/business/file_size_to_text.dart";

class VideoDetails {
  VideoDetails({
    required this.sizeInBytes,
    required this.name,
    required this.fileReference,
  });

  final int sizeInBytes;

  /// Filename including extension
  final String name;
  final File fileReference;

  String get sizeString => fileSizeToText(sizeInBytes);
  String get fileNameShort {
    return getShortFileName(fileName: name);
  }

  static String getShortFileName({required String fileName}) {
    return fileName.substring(0, min(12, fileName.length)) +
        (fileName.length > 12
            ? fileName.length > 27
                ? "...${fileName.substring(
                    fileName.length - 12,
                    fileName.length,
                  )}"
                : fileName.substring(12, fileName.length)
            : "");
  }
}
