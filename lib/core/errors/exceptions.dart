class NoFilesFoundExcepetion implements Exception {}

class FileErrorException implements Exception {
  final String fileName;
  FileErrorException({
    required this.fileName,
  });
}
