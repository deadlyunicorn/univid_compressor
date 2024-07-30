import "dart:io";

extension CopyOriginalFileDetails on File {
  Future<bool> copyOriginalFileDetails(File originalFile) async {
    try {
      if (Platform.isLinux) {
        await Process.run(
          "touch",
          <String>["-r", originalFile.absolute.path, absolute.path],
        );
        return true;
      } else if (Platform.isAndroid) {
        throw UnimplementedError(); //TODO
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }
}
