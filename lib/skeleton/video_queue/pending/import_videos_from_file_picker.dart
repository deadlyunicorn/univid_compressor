import "dart:io";

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
}
