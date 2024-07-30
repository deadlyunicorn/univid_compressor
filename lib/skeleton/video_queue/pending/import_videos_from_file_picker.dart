import "dart:io";
import "package:cross_file/cross_file.dart";
import "package:desktop_drop/desktop_drop.dart";

import "package:file_picker/file_picker.dart";
import "package:univid_compressor/core/errors/exceptions.dart";
import "package:univid_compressor/core/video_details.dart";

class VideoImport {
  static Future<List<VideoDetails>>
      importVideoDetailsListFromFilePicker() async {
    final FilePickerResult? filePickerResult =
        await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.video,
    );

    if (filePickerResult != null) {
      return filePickerResult.files
          .where((PlatformFile platformFile) {
            if (platformFile.path == null) {
              throw FileErrorException(
                fileName: platformFile.name,
              );
            }
            return true;
          })
          .map(
            (PlatformFile platformFile) => VideoDetails(
              sizeInBytes: platformFile.size,
              name: platformFile.name,
              fileReference: File(platformFile.path!),
            ),
          )
          .toList();
    } else {
      throw NoFilesFoundExcepetion();
    }
  }

  static Future<List<VideoDetails>> importVideoDetailsListFromDesktopDrop(
    DropDoneDetails details,
  ) async {
    final List<XFile> xFiles = details.files;

    if (xFiles.isNotEmpty) {
      return xFiles.map((XFile xFile) {
        final File file = File(xFile.path);
        if (!file.existsSync()) {
          throw FileErrorException(
            fileName: xFile.name,
          );
        }
        return VideoDetails(
          sizeInBytes: file.lengthSync(),
          name: xFile.name,
          fileReference: File(xFile.path),
        );
      }).toList();
    } else {
      throw NoFilesFoundExcepetion();
    }
  }

  //TODO: move this class closer to video details
  //TODO: include import from filepath.
}
