class NoFilesFoundExcepetion implements Exception {}

class FileErrorException implements Exception {
  final String fileName;
  FileErrorException({
    required this.fileName,
  });
}

class SystemNotSupportedException implements Exception {}
class MD5CheckFailedException implements Exception {}
