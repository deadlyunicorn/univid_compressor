import "dart:io";

import "package:path_provider/path_provider.dart";

class UnividFilesystem {
  static Future<Directory> get directory async =>
      await getApplicationDocumentsDirectory().then((Directory dir) async {
        final Directory unividDir =
            await Directory("${dir.path}/univid").create();
        return unividDir;
      });

  static Future<Directory> get ffmpegDir async =>
      Directory("${(await UnividFilesystem.directory).path}/ffmpeg_static");
}
